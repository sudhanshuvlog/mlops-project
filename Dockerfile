FROM python:3.10-slim
WORKDIR /app
COPY . .
RUN pip3 install -r requirements.txt

# Set up entrypoint script to pull models from DVC on startup
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Pulling DVC artifacts from S3..."\n\
dvc pull || echo "Warning: DVC pull failed - models may not be available"\n\
echo "Starting API server..."\n\
exec uvicorn src.app:app --host 0.0.0.0 --port 8000\n\
' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]