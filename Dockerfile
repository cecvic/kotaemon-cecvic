FROM python:3.9-slim AS full

     # Additional dependencies for full version
     RUN apt-get update -qqy && \
         apt-get install -y --no-install-recommends \
           tesseract-ocr \
           tesseract-ocr-jpn \
           libsm6 \
           libxext6 \
           libreoffice \
           ffmpeg \
           libmagic-dev

     # Install torch and torchvision for unstructured
     RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

     # Install additional pip packages
     RUN pip install -e "libs/kotaemon[adv]" \
         && pip install unstructured[all-docs]

     # Clean up
     RUN apt-get autoremove \
         && apt-get clean \
         && rm -rf /var/lib/apt/lists/* \
         && rm -rf ~/.cache

     # Download nltk packages as required for unstructured
     RUN python -c "from unstructured.nlp.tokenize import _download_nltk_packages_if_not_present; _download_nltk_packages_if_not_present()"

     CMD ["python", "app.py"]
