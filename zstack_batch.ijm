#@ File (label = "Input directory", style = "directory") input
#@ String (label = "File suffix", value = ".tif") suffix

#@ String (choices={"Max Intensity", "Average Intensity", "Min Intensity", "Sum Slices", "Standard Deviation", "Median"}) zproject

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, list[i], zproject);
	}
}

function processFile(input, file, zproject) {
	// open one image
	run("Bio-Formats", "open=[" + input + "/" + file +"]");
  	originalTitle = getTitle();
  	getDimensions(width, height, channels, slices, frames);
	selectWindow(originalTitle);
	tempChTitle = getTitle();
	run("Z Project...", "projection=[" + zproject + "]");
	rename("MAX_" + tempChTitle);
	selectWindow(tempChTitle);
	close();
}


run("Images to Stack", "name=Stack title=[] use keep");
selectWindow("Stack");
run("StackReg ", "transformation=Affine");