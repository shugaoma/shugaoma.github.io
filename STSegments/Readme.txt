Matlab code for extracting hierarchical space-time segments, which can be used for action recognition and localization. Users of our code are asked to cite the following publication:

@inproceedings{shugao2013,
 title={Action Recognition and Localization by Hierarchical Space-Time Segments},
 author={Shugao Ma, Jianming Zhang, Nazli Ikizler-Cinbis and Stan Sclaroff},
 booktitle={Proc. of the IEEE International Conference on Computer Vision (ICCV)},
 year={2013}
}

To compile, you need to edit the file "lib/compile.m" to fill in your opencv paths. Note this code is tested using opencv 2.4 and opencv 2.6 under 64 bit scientific linux. 

To visually see the extracted space-time segments, run visualizeDemo.m in matlab. It uses pre-computed space-time segments of demo video. 

To extract space-time segments from the demo video, run demo.m in matlab. 

If you have any problems, suggestions or bug reports about this software, please contact shugaoma@bu.edu

Disclaimer:

This code relies on other researcher's code. To make this package self-contained, we included some of those code. The code we included are:
1. Image boundary detection code by Marius Leordeanu et al. at . The original code can be found at http://109.101.234.42/documente/code/doc_8.zip

2. Ultra metric contour map computation code by Pablo Arbelaez et al. at the Computer Vision Group of UC Berkeley. The original code can be found at http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html

The demo video is from the dataset UCFSports, which is collected by Mikel D. Rodriguez et al.. The whole dataset can be found at http://crcv.ucf.edu/data/UCF_Sports_Action.php.