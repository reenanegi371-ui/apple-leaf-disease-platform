"""
Start both Backend (FastAPI) and Frontend (Flask) servers together.
Run this from the apple-leaf-disease-platform folder:
    python start.py
"""

import subprocess
import sys
import os
import time
import threading

# Fix Windows terminal encoding
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.join(BASE_DIR, "backend")
WEBSITE_DIR = os.path.join(BASE_DIR, "website")


def stream_output(process, prefix):
    """Print output from a subprocess with a prefix label."""
    for line in iter(process.stdout.readline, b""):
        print(f"[{prefix}] {line.decode().rstrip()}")


def clear_ports():
    """Kill any process holding port 8000 or 5000."""
    print("[INFO] Checking for stuck processes on ports 8000 and 5000...")
    for port in [8000, 5000]:
        try:
            # Command to find process ID on a port and kill it
            cmd = f'powershell -Command "Get-NetTCPConnection -LocalPort {port} -ErrorAction SilentlyContinue | ForEach-Object {{ Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }}"'
            subprocess.run(cmd, shell=True)
        except:
            pass

def main():
    clear_ports()  # Clear ports first!
    print("=" * 55)
    print("  LeafHealth AI - Starting All Servers")
    print("=" * 55)
    print("  Backend  --> http://127.0.0.1:8000")
    print("  Frontend --> http://127.0.0.1:5000")
    print("=" * 55)
    print("  Press Ctrl+C to stop both servers\n")

    python = sys.executable

    # Start backend
    backend = subprocess.Popen(
        [python, "main.py"],
        cwd=BACKEND_DIR,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    # Start frontend
    frontend = subprocess.Popen(
        [python, "run.py"],
        cwd=WEBSITE_DIR,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    # Stream output from both in separate threads
    threading.Thread(target=stream_output, args=(backend, "BACKEND "), daemon=True).start()
    threading.Thread(target=stream_output, args=(frontend, "FRONTEND"), daemon=True).start()

    try:
        while True:
            time.sleep(1)
            # If either process dies, stop everything
            if backend.poll() is not None:
                print("\n[ERROR] Backend stopped unexpectedly!")
                frontend.terminate()
                break
            if frontend.poll() is not None:
                print("\n[ERROR] Frontend stopped unexpectedly!")
                backend.terminate()
                break
    except KeyboardInterrupt:
        print("\n\n[INFO] Shutting down both servers...")
        backend.terminate()
        frontend.terminate()
        print("[INFO] Done. Goodbye! 👋")


if __name__ == "__main__":
    main()
