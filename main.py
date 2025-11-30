import socket
import threading

class TCPServer:
    def __init__(self, host='localhost', port=9090):
        self.host = host
        self.port = port
        self.socket = None
        self.running = False
        
    def start(self, message_handler=None):
        """Запуск сервера с обработчиком сообщений"""
        def handle_client(client_socket, address):
            print(f"Новое подключение: {address}")
            while True:
                try:
                    # Получаем сообщение
                    data = client_socket.recv(1024).decode('utf-8')
                    if not data:
                        break
                    
                    print(f"Получено от {address}: {data}")
                    
                    # Вызываем обработчик если он есть
                    if message_handler:
                        response = message_handler(data, address)
                        if response:
                            client_socket.send(response.encode('utf-8'))
                    else:
                        # Автоответ
                        client_socket.send(f"Сообщение получено: {data}".encode('utf-8'))
                        
                except Exception as e:
                    print(f"Ошибка: {e}")
                    break
            
            client_socket.close()
            print(f"Клиент отключен: {address}")
        
        try:
            self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.socket.bind((self.host, self.port))
            self.socket.listen(5)
            self.running = True
            
            print(f"Сервер запущен на {self.host}:{self.port}")
            
            while self.running:
                client_socket, address = self.socket.accept()
                client_thread = threading.Thread(target=handle_client, args=(client_socket, address))
                client_thread.daemon = True
                client_thread.start()
                
        except Exception as e:
            print(f"Ошибка сервера: {e}")
            
    def stop(self):
        """Остановка сервера"""
        self.running = False
        if self.socket:
            self.socket.close()

# Простой запуск сервера
def start_simple_server():
    server = TCPServer()
    
    def custom_handler(message, address):
        print(f"Обработка сообщения '{message}' от {address}")
        return f"ECHO: {message}"
    
    server.start(message_handler=custom_handler)

if __name__ == "__main__":
    start_simple_server()