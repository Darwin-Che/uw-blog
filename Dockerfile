FROM darwinche/uw-blog:v3
WORKDIR /code
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["chmod u+x host.sh"]
CMD ["./host.sh"]
