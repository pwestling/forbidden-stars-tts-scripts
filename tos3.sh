#!/bin/bash

TRANSFORM="(.. | .CustomMesh? | select(type != "null") | .$thing | select(. != "" and (contains("s3.amazon") | not))) |= $trans"
F=$1

rewrite(){
 thing=$1
 trans=$2
 cat tmp.json | jq -r "(.. | .CustomMesh? | select(type != \"null\") | .${thing} | select(. != \"\" and (contains(\"s3.amazon\") | not))) |= ${trans}" > tmp1.json
 mv tmp1.json tmp.json
}
rewrite_deck(){
 thing=$1
 trans=$2
 cat tmp.json | jq -r "(.. | .CustomDeck? | select(type != \"null\") | .. | .${thing} | select(. != \"\" and (contains(\"s3.amazon\") | not))) |= ${trans}" > tmp1.json
 mv tmp1.json tmp.json
}
rewrite_image(){
 thing=$1
 trans=$2
 cat tmp.json | jq -r "(.. | .CustomImage? | select(type != \"null\") | .${thing} | select(. != \"\" and (contains(\"s3.amazon\") | not))) |= ${trans}" > tmp1.json
 mv tmp1.json tmp.json
}

remove_special="gsub(\"[-/:&+?=._%]\";\"\")"
amazonifyobj='sub("(?<path>.*)";"https://s3.amazonaws.com/forbidden-stars-assets/\(.path).obj")'
amazonifyobj='sub("(?<path>.*)";"https://s3.amazonaws.com/forbidden-stars-assets/\(.path).obj")'
amazonifypng='sub("(?<path>.*)";"https://s3.amazonaws.com/forbidden-stars-assets/\(.path).png")'
amazonifyjpg='sub("(?<path>.*)";"https://s3.amazonaws.com/forbidden-stars-assets/\(.path).jpg")'

cat $F > tmp.json

rewrite "ColliderURL" $remove_special
rewrite "MeshURL" $remove_special
rewrite "DiffuseURL" $remove_special
rewrite_deck "FaceURL? | select(type != \"null\")" $remove_special
rewrite_deck "BackURL? | select(type != \"null\")" $remove_special
rewrite_image "ImageURL" $remove_special

rewrite "ColliderURL" $amazonifyobj
rewrite "MeshURL" $amazonifyobj
rewrite "DiffuseURL | select(contains(\"png\"))" $amazonifypng
rewrite "DiffuseURL | select(contains(\"jpg\"))" $amazonifyjpg
rewrite "DiffuseURL" $amazonifyjpg
rewrite_image "ImageURL | select(contains(\"png\"))" $amazonifypng
rewrite_image "ImageURL | select(contains(\"jpg\"))" $amazonifyjpg
rewrite_image "ImageURL" $amazonifyjpg
rewrite_deck "FaceURL? | select(type != \"null\") | select(contains(\"png\"))" $amazonifypng
rewrite_deck "FaceURL? | select(type != \"null\") | select(contains(\"jpg\"))" $amazonifyjpg
rewrite_deck "FaceURL? | select(type != \"null\")" $amazonifyjpg
rewrite_deck "BackURL? | select(type != \"null\") | select(contains(\"png\"))" $amazonifypng
rewrite_deck "BackURL? | select(type != \"null\") | select(contains(\"jpg\"))" $amazonifyjpg
rewrite_deck "BackURL? | select(type != \"null\")" $amazonifyjpg
cat tmp.json | jq .


