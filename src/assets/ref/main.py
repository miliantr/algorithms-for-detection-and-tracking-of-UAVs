import socket

HOST = "127.0.0.1"
PORT = 8888

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print(f"Listening on {HOST}:{PORT}")
    conn, addr = s.accept() # Accept incoming connection
    with conn:
        print(f"Connected by {addr}")
        while True:
            data = conn.recv(1024) # Receive up to 1024 bytes
            if not data:
                break
            #print(f"Received: {data.decode()}")
            conn.sendall(data) # Echo back the received data
