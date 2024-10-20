# bank_api

This is a Bank API project implemented using Python, following Domain-Driven Design (DDD) principles and Test-Driven Development (TDD) practices.

## Project Structure

The project follows a structure inspired by Go standard layout, adapted for Python and DDD:

- `commands/`: Contains the main entry points for the application.
- `internal/`: Contains the core application code, divided into DDD layers.
- `pkg/`: Contains library code that can be used by external applications.
- `tests/`: Contains all test code, supporting TDD approach.
- `docs/`: Contains project documentation.
- `scripts/`: Contains various scripts for building, installing, analyzing, etc.
- `deployment/`: Contains deployment configurations and templates.

## Getting Started

1. Clone the repository
2. Create and activate the virtual environment:
   ```
   python3 -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```
3. Install dependencies: `pip install -r requirements.txt`
4. Run the application: `python commands/server/main.py`

## Running Tests

With the virtual environment activated, run `pytest` in the project root directory.

## Docker Development

1. Build the Docker image: `docker-compose build`
2. Run the services: `docker-compose up`

## Deployment

This project is configured for deployment on Google Cloud Run. Refer to the deployment documentation in the `docs/` directory for detailed instructions.

## Contributing

[Add contribution guidelines]

## License

[Add license information]
