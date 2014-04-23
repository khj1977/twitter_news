package com.gmail.eulerbonjour.app;

import java.io.*;
import java.util.*;
import no.uib.cipr.matrix.*;

public class KMeans {

    // cluster centre
    protected DenseVector[] clusterCentres;
    // protected ArrayList<DenseVector> dataSet;
    protected DenseVector[] dataSet;
    protected ArrayList<String> dataLabel;
    protected int numClusters;
    protected int dimData;

    // The index to cluster centre of data vector. val is idx of cluster
    protected Integer[] belongingClusters;
    
    // key: idx of cluster as String. val: list of idx of dataSet
    protected HashMap<String, ArrayList<Integer>> clusterMap;

    static public void main(String args[]) throws Exception {
	if (args.length != 3) {
	    System.out.println("usage: prog data-path dim-data num-cluster");

	    return;
	}

	String dataPath = args[0];
	int dimData = Integer.parseInt(args[1]);
	int numCluster = Integer.parseInt(args[2]);

	KMeans app = new KMeans(dataPath, dimData, numCluster);

	app.calcCluster();
    }

    public KMeans(String dataPath, int dimData, int numCluster) throws Exception {
	this.clusterCentres = new DenseVector[numCluster];
	ArrayList<DenseVector> tmpDataSet = new ArrayList<DenseVector>();
	this.numClusters = numCluster;
	this.dimData = dimData;
	this.dataLabel = new ArrayList<String>();

	for(int i = 0; i < numCluster; ++i) {
	    this.clusterCentres[i] = new DenseVector(dimData);
	}

	int idxDataVec = 0;
	try {
	    BufferedReader inputStream = 
		new BufferedReader(new FileReader(dataPath));
	    
	    while(inputStream.ready()) {
		String line = inputStream.readLine();
		line = line.replaceAll("\n", "");
		
		String[] splitted = line.split("\t");
		
		String dataName = splitted[0];
		this.dataLabel.add(dataName);
		int n = splitted.length;
		DenseVector dataVector = new DenseVector(dimData);
		dataVector.zero();
		int k = 0;
		for(int j = 2; j < n; j = j + 2) {
		    int idx = j - 1;
		    dataVector.add(k, Double.parseDouble(splitted[j]));

		    ++k;
		}

		tmpDataSet.add(dataVector);

		++idxDataVec;
	    }
	}
	catch(IOException ex) {
	    throw new Exception(ex.getMessage());
	}

	this.dataSet = new DenseVector[tmpDataSet.size()];
	this.dataSet = tmpDataSet.toArray(this.dataSet);
	this.belongingClusters = new Integer[this.dataLabel.size()];
    }

    public void calcCluster() {
	this.pickClusterRandomly();

	int numLoop = 0;
	while(true) {
	    // System.out.println("num-loop: " + numLoop);

	    if (numLoop == 100) {
		break;
	    }

	    // debug
	    System.out.println("new clusster centre");
	    // end of debug
	    for(int i = 0; i < this.numClusters; ++i) {
		this.calcClusterCentre(i);
	    }
	    
	    // debug
	    System.out.println("choose new cluster");
	    // end of debug
	    this.clusterMap = new HashMap<String, ArrayList<Integer>>();
	    boolean allNotChanged = true;
	    for(int i = 0; i < this.dataSet.length; ++i) {
		// 各データについて、新しいクラスタを選択する
		boolean changed = this.chooseNewCluster(i);
		
		if (changed == true) {
		    allNotChanged = false;
		}
	    }

	    if (allNotChanged == true) {
		break;
	    }
	    
	    ++numLoop;
	}

	Iterator<String> clusterNumItr = this.clusterMap.keySet().iterator();
	while(clusterNumItr.hasNext()) {
	    String clusterNumAsString = clusterNumItr.next();
	    ArrayList<Integer> dataIdxs = 
		this.clusterMap.get(clusterNumAsString);

	    // String outString = clusterNumAsString;
	    Integer clusterNum = Integer.parseInt(clusterNumAsString);
	    DenseVector clusterCentre = this.clusterCentres[clusterNum];
	    Double v1 = clusterCentre.get(0);
	    Double v2 = clusterCentre.get(1);
	    Double v3 = clusterCentre.get(2);
	    String outString = v1.toString() + "\t" + v2.toString() + "\t" +
		v3.toString();
	    for(int i = 0; i < dataIdxs.size(); ++i) {
		int dataIdx = dataIdxs.get(i);
		String label = this.dataLabel.get(dataIdx);

		outString = outString + "\t" + label;
	    }

	    outString = outString + "\t" + "\n\n";
	    System.out.println(outString);
	}

	/*
	int n = this.dataLabel.size();
	for(int i = 0; i < n; ++i) {
	    Integer clusterNum = this.belongingClusters[i];
	    String label = this.dataLabel.get(i);

	    System.out.println(clusterNum.toString() + 
			       "\t" + 
			       label);
	}
	*/

    }

    protected double get2Norm(no.uib.cipr.matrix.Vector v) {
	int dim = v.size();

	double norm = 0.0;
	for (int i = 0; i < dim; ++i) {
	    double val = v.get(i);
	    norm = norm + val*val;
	}

	return Math.sqrt(norm);
    }


    protected boolean chooseNewCluster(Integer dataIdx) {
	double min = 1000000000.0;
	Integer minIdx = -1;

	int oldClusterIdx = this.belongingClusters[dataIdx];

	for(int i = 0; i < this.numClusters; ++i) {
	    no.uib.cipr.matrix.Vector dataVec = this.dataSet[dataIdx].copy();
	    // no.uib.cipr.matrix.Vector dataVec = this.dataSet[dataIdx];

	    no.uib.cipr.matrix.Vector clusterCentre = this.clusterCentres[i];

	    dataVec = dataVec.add(-1.0, clusterCentre);
	    // double norm = this.get2Norm(dataVec);
	    //double norm = 1.0;
	    double norm = dataVec.norm(no.uib.cipr.matrix.Vector.Norm.Two);
	    
	    if (norm < min) {
		min = norm;
		minIdx = i;
	    }
	}

	this.belongingClusters[dataIdx] = minIdx;

	if (this.clusterMap.get(minIdx.toString()) == null) {
	    this.clusterMap.put(minIdx.toString(), new ArrayList<Integer>());
	}
	ArrayList<Integer> dataIdxs = this.clusterMap.get(minIdx.toString());

	dataIdxs.add(dataIdx);
	this.clusterMap.put(minIdx.toString(), dataIdxs);

	if (oldClusterIdx == minIdx) {
	    return true;
	}
	
	return false;
    }

    protected void calcClusterCentre(Integer clusterIdx) {
	ArrayList<Integer> dataIdxs =
	    this.clusterMap.get(clusterIdx.toString());

	if (dataIdxs == null) {
	    return;
	}
	
	no.uib.cipr.matrix.Vector centre = new DenseVector(this.dimData);
	centre.zero();

	int numVec = 0;
	Iterator<Integer> itr = dataIdxs.iterator();

	while(itr.hasNext()) {
	    Integer dataIdx = itr.next();

	    no.uib.cipr.matrix.Vector data = this.dataSet[dataIdx];
	    centre = centre.add(data);

	    ++numVec;
	}

	// double factor = 1.0 / (double)numVec;
	double factor = 1.0 / centre.norm(no.uib.cipr.matrix.Vector.Norm.Two);
	centre = centre.scale(factor);

	this.clusterCentres[clusterIdx] = (DenseVector)centre;
    }

    protected void pickClusterRandomly() {
	this.clusterMap = new HashMap<String, ArrayList<Integer>>();

	Random rand = new Random();

	int n = this.dataLabel.size();
	for(int i = 0; i < n; ++i) {
	    Integer idxCluster = rand.nextInt(this.numClusters);
	    this.belongingClusters[i] = idxCluster;

	    ArrayList<Integer> dataIdxs = 
		this.clusterMap.get(idxCluster.toString());
	    if (dataIdxs == null) {
		dataIdxs = new ArrayList<Integer>();
	    }
	    dataIdxs.add(i);
	    this.clusterMap.put(idxCluster.toString(), dataIdxs);
	}
    }
    

}