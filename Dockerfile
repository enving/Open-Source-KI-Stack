FROM deepset/hayhooks:main

# Install trafilatura since it's a required dependency
# For our chat_with_website sample pipeline
RUN pip install trafilatura

CMD ["hayhooks", "run", "--host", "0.0.0.0"]
