From python:3.11

COPY ./requirements.txt .
RUN  pip install -r requirements.txt

CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password='@rtificialWisd0m'", "--NotebookApp.allow_origin='*'", "--NotebookApp.allow_remote_access='*'", "--NotebookApp.notebook_dir='/notebooks'"]
