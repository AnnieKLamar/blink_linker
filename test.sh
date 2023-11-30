#!/bin/sh

while getopts p: flag
do 
	case "${flag}" in
		p) path=${OPTARG};;
	esac
done
ml purge

echo "##### Removing previous installations at $path #####"
echo ""
rm -r -f $path

echo "##### Installing miniconda at $path #####"
echo ""

mkdir $path
cd $path
mkdir $path/miniconda
cd $path/miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $path/miniconda3
cd $path
echo "Cloning BLINK repository..."
git clone https://github.com/facebookresearch/BLINK
echo "Creating conda environments..."
conda create -n blink37 -y python=3.7 && source activate blink37
echo "## Installing requirements ##"
cd $path/BLINK
pip install -r requirements.txt
echo "## Downloading BLINK models ##"
chmod +x download_blink_models.sh 
./download_blink_models.sh 
echo "## Running interactive module ##"
python blink/main_dense.py -i --fast
