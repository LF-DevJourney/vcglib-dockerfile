FROM ubuntu:14.04

RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install build-essential

RUN git clone https://github.com/cnr-isti-vclab/vcglib.git

# without color, it will cause the assertion 0 exception
RUN sed -i 's/^\s*class\s*MyVertex\s*:\s*public.*$/class MyVertex  : public vcg::Vertex< MyUsedTypes, vcg::vertex::Coord3f, vcg::vertex::Normal3f, vcg::vertex::BitFlags, vcg::vertex::Color4b >{};/g' $(find / -name trimesh_clustering.cpp)
# make the trimesh_clustering applied for common file type.
RUN sed -i 's/ImporterPLY/Importer/g' $(find / -name trimesh_clustering.cpp)
RUN sed -i 's/ExporterPLY/Exporter/g' $(find / -name trimesh_clustering.cpp)

RUN g++ -std=c++11 -g -I /vcglib $(find / -name plylib.cpp) $(find / -name trimesh_clustering.cpp) -o trimesh_clustering
