FROM python:3.8

# Set environment varialbls
# 禁用每次对pip更新的自动检查
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
# 这意味着Python将不会尝试编写.pyc文件 pythondontwritebytecode
ENV PYTHONDONTWRITEBYTECODE 1
# 确保我们的控制台输出不被Docker缓冲 pythonunbuffered
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY ./requirements.txt .
RUN pip3 install -r requirements.txt



COPY . .

RUN make build_sandbox

