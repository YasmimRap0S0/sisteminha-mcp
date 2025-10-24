# server_mcp.py
from mcp.server.fastmcp import FastMCP
import requests

# Cria o servidor MCP
mcp = FastMCP("sisteminha")

# Tool: buscar dados da API Django
@mcp.tool()
def buscar_usuario(user_id: int):
    """Busca dados de um usuário via API Django"""
    resp = requests.get(f"http://localhost:8000/api/usuarios/{user_id}/")
    if resp.status_code != 200:
        return {"erro": f"Falha ao buscar usuário {user_id}"}
    return resp.json()

# Tool: criar novo registro
@mcp.tool()
def criar_usuario(nome: str, email: str):
    """Cria um novo usuário via API Django"""
    resp = requests.post("http://localhost:8000/api/usuarios/", json={
        "nome": nome,
        "email": email
    })
    return resp.json()

# Prompt: gerar instruções de uso
@mcp.prompt()
def instrucoes():
    return "Você pode usar as ferramentas 'buscar_usuario' e 'criar_usuario'."

if __name__ == "__main__":
    mcp.serve()  # inicia o servidor MCP corretamente
