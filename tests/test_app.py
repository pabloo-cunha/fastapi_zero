from http import HTTPStatus

from fastapi.testclient import TestClient

from fastapi_zero.src.app import app

client = TestClient(app)  # Arrange


def test_read_root():
    """
    Esse teste tem 3 AAA:
    A - Arrange: Configurar o cenário do teste.
    A - Act: Executar a ação que queremos testar.
    A - Assert: Verificar se o resultado é o esperado.
    """

    response = client.get('/')  # Act

    assert response.status_code == HTTPStatus.OK  # Assert

    assert response.json() == {'message': 'Hello World'}  # Assert
