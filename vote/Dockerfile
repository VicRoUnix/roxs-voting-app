FROM python:3.9.24-slim
WORKDIR /app
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

COPY . .

RUN chown -R appuser:appgroup /app

USER appuser

CMD ["python3", "app.py"]
