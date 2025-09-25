from simple_flask_app.app import app

def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    # Update expected string to match what your app returns
    assert b"Welcome everyone! David DevOps!" in response.data


