#!/bin/bash

read COUNT echo $COUNT
echo $((COUNT+1)) > $LOCAL_DATA"SKUs/sku"
