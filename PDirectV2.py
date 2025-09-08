import socket
import threading
import select
import sys
import time
import argparse
import ssl
from datetime import datetime

# Configuración
DEFAULT_HOST = '127.0.0.1:22'
BUFLEN = 4096 * 4
TIMEOUT = 60
PASS = ''
LOG_FILE = 'proxy_connections.log'
SSL_CERT = 'cert.pem'
SSL_KEY = 'key.pem'

RESPONSE = (
    b'HTTP/1.1 101 Switching Protocols\r\n'
    b'Content-length: 0\r\n\r\n'
    b'HTTP/1.1 101 Connection established\r\n\r\n'
)

class Server(threading.Thread):
    def __init__(self, host, port, use_ssl=False):
        super().__init__()
        self.host = host
        self.port = port
        self.use_ssl = use_ssl
        self.running = False
        self.threads = []
        self.threads_lock = threading.Lock()
        self.log_lock = threading.Lock()

    def run(self):
        self.running = True
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((self.host, self.port))
        sock.listen(100)
        sock.settimeout(2)

        if self.use_ssl:
            context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
            context.load_cert_chain(certfile=SSL_CERT, keyfile=SSL_KEY)
            self.soc = context.wrap_socket(sock, server_side=True)
        else:
            self.soc = sock

        print(f"[INFO] Proxy activo {'con SSL' if self.use_ssl else 'sin SSL'} en {self.host}:{self.port}")

        threading.Thread(target=self.print_active_connections, daemon=True).start()

        while self.running:
            try:
                client_sock, addr = self.soc.accept()
                client_sock.setblocking(True)
                handler = ConnectionHandler(client_sock, self, addr)
                handler.start()
                self.add_connection(handler)
            except socket.timeout:
                continue
            except ssl.SSLError as e:
                self.log(f"[SSL ERROR] {e}")

    def add_connection(self, conn):
        with self.threads_lock:
            if self.running:
                self.threads.append(conn)

    def remove_connection(self, conn):
        with self.threads_lock:
            if conn in self.threads:
                self.threads.remove(conn)

    def close(self):
        self.running = False
        with self.threads_lock:
            for conn in list(self.threads):
                conn.close()

    def log(self, message):
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        full = f"[{timestamp}] {message}"
        with self.log_lock:
            print(full)
            with open(LOG_FILE, 'a') as f:
                f.write(full + '\n')

    def print_active_connections(self):
        while self.running:
            time.sleep(10)
            with self.threads_lock:
                active = len(self.threads)
                print(f"[PANEL] Conexiones activas: {active}")
                for t in self.threads:
                    print(f"    - {t.addr}")
                print("-" * 40)


class ConnectionHandler(threading.Thread):
    def __init__(self, client_sock, server, addr):
        super().__init__()
        self.client = client_sock
        self.server = server
        self.addr = addr
        self.client_closed = False
        self.target_closed = True
        self.client_buffer = b""
        self.request_line = ""

    def close(self):
        if not self.client_closed:
            try:
                self.client.shutdown(socket.SHUT_RDWR)
            except:
                pass
            self.client.close()
            self.client_closed = True

        if hasattr(self, 'target') and not self.target_closed:
            try:
                self.target.shutdown(socket.SHUT_RDWR)
            except:
                pass
            self.target.close()
            self.target_closed = True

    def run(self):
        host_port = ""
        status = "UNKNOWN"
        try:
            self.client_buffer = self.client.recv(BUFLEN)
            headers = self.client_buffer.decode(errors="ignore")
            self.request_line = headers.split('\r\n')[0] if headers else ""
            host_port = self.find_header(headers, 'X-Real-Host') or DEFAULT_HOST
            passwd = self.find_header(headers, 'X-Pass')
            split = self.find_header(headers, 'X-Split')

            if split:
                self.client.recv(BUFLEN)

            if PASS and passwd != PASS:
                self.client.sendall(b'HTTP/1.1 403 Forbidden\r\n\r\n')
                status = "REJECTED - Wrong password"
                return

            if host_port.startswith('127.0.0.1') or host_port.startswith('localhost') or PASS == '' or passwd == PASS:
                self.method_connect(host_port)
                status = "ACCEPTED"
            else:
                self.client.sendall(b'HTTP/1.1 403 Forbidden\r\n\r\n')
                status = "REJECTED - Host not allowed"

        except Exception as e:
            status = f"ERROR - {e}"
        finally:
            self.server.log(f"{self.addr} -> {host_port} | {self.request_line} | {status}")
            self.close()
            self.server.remove_connection(self)

    def find_header(self, headers, key):
        for line in headers.split('\r\n'):
            if line.lower().startswith(key.lower() + ":"):
                return line.split(":", 1)[1].strip()
        return ''

    def method_connect(self, target_host):
        self.connect_target(target_host)
        self.client.sendall(RESPONSE)
        self.client_buffer = b''
        self.handle_tunnel()

    def connect_target(self, host):
        host, _, port = host.partition(':')
        port = int(port or 80)
        addr_info = socket.getaddrinfo(host, port)[0]
        self.target = socket.socket(addr_info[0], addr_info[1], addr_info[2])
        self.target.connect(addr_info[4])
        self.target_closed = False

    def handle_tunnel(self):
        sockets = [self.client, self.target]
        last_active = time.time()

        while True:
            readable, _, errored = select.select(sockets, [], sockets, 1)
            if errored:
                break
            if readable:
                for sock in readable:
                    try:
                        data = sock.recv(BUFLEN)
                        if not data:
                            return
                        if sock is self.client:
                            self.target.sendall(data)
                        else:
                            self.client.sendall(data)
                        last_active = time.time()
                    except Exception:
                        return
            if time.time() - last_active > TIMEOUT:
                break


def parse_args():
    parser = argparse.ArgumentParser(description='Proxy con logging, panel y SSL opcional.')
    parser.add_argument('-b', '--bind', default='0.0.0.0', help='IP de escucha')
    parser.add_argument('-p', '--port', type=int, default=8080, help='Puerto de escucha')
    parser.add_argument('--ssl', action='store_true', help='Habilitar SSL con cert.pem y key.pem')
    return parser.parse_args()


def main():
    args = parse_args()
    print("\n:------ PythonProxy v3 ------:")
    print(f"Escuchando en: {args.bind}:{args.port}")
    print(f"SSL: {'Sí' if args.ssl else 'No'}")
    print(":----------------------------:\n")

    server = Server(args.bind, args.port, args.ssl)
    server.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Apagando proxy...")
        server.close()


if __name__ == '__main__':
    main()
