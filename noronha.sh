#!/bin/bash

nha -d -p model new \
--name sentiment-clf \
--data-file '{"name": "train.txt", "required": true, "max_mb": 4096, "desc": "TXT with phrases and labels"}' \
--model-file '{"name": "fasttext.ftz", "required": true, "max_mb": 1024, "desc": "Fasttext binary"}'

nha -d -p proj new \
--name sentiments \
--model sentiment-clf \
--home-dir . \
--docker-repo gcr.io/calm-premise-168420/nha-proj-sentiments

nha -d -p proj build

nha -d -p note --edit --port 9090 --ds sentiment-clf:amazon-reviews

nha -d -p ds new \
--name amazon-reviews \
--model sentiment-clf \
--path ./datasets/ \
--details '{"load_date": "2022-03-17"}'

nha -d -p train new \
--name amazon-reviews \
--proj sentiments \
--nb notebooks/train \
--params '{"epoch": 2}' \
--ds sentiment-clf:amazon-reviews

nha -d -p depl new \
--name prediction \
--proj sentiments \
--nb notebooks/predict \
--mv sentiment-clf:amazon-reviews \
--port 30090 \
--rp nha-predict
