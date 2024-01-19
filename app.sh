#!/bin/bash

sudo yum install -y libXrender && yum clean all

streamlit run \
          --server.address 0.0.0.0 \
          --server.port 8080 \
          --server.headless True \
          poxload_streamlit.py
