#!/usr/bin/perl -w

#perl gen_network.pl /exports/store1/rnaseq/1/pvalue23_15.txt /exports/store1/rnaseq/1/count23_15.txt /exports/store1/rnaseq/1/function.txt /exports/store1/rnaseq/transcription_factors/mouse_regulator.txt /exports/store1/rnaseq/1

$numArgs = @ARGV;
if($numArgs != 7)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$pfile			= "$ARGV[0]";
$countfile		= "$ARGV[1]";
$function_result= "$ARGV[2]";
$tf				= "$ARGV[3]";
$outfolder		= "$ARGV[4]";
$pvalue			= "$ARGV[5]";
$id2name		= "$ARGV[6]";

$perlpath		= "/exports/store1/rnaseq/tools/network";
$matlabpath		= "/exports/store1/rnaseq/tools/network/matlab_2013a/";

print "\n**************************************************\n";
print "run gen_network_p.pl\n";

if (!-e $outfolder) {`mkdir $outfolder`;}

chdir($outfolder) or die "$! Failed chdir $outfolder";

#Get idall while p value is lower than a threshold (0.05 or 0.01)
$status =system("perl $perlpath/findidall_2.pl $pfile $pvalue $outfolder/idall.txt"); 
if ($status){
	$error_msg = "ERROR! findidall_2 execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! findidall_2 execution failed!";
}

#Get idnew while genes exist in regulator file
$status =system("perl $perlpath/findidnew.pl $outfolder/idall.txt $tf $outfolder/idnew.txt"); 
if ($status){
	$error_msg = "ERROR! findidnew execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! findidnew execution failed!";
}

#Get ep
$status =system("perl $perlpath/getep.pl $countfile $outfolder/idall.txt $outfolder/ep.txt $outfolder/ep0.txt"); 
if ($status){
	$error_msg = "ERROR! getep execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! getep execution failed!";
}

#Generate leibiebianhao (Matlab)
#kmeans
#input: matrix of numbers
#output: clusters in one column
$log1=$outfolder."/GenLeibiebianhao.log";
$status =system("/usr/local/MATLAB/R2013a/bin/matlab -nojvm -nodisplay -nosplash -logfile $log1 -r \"data1 = dlmread('$outfolder/ep0.txt'); nr = size(data1,1); c1 = ceil(nr/50); if c1>50 c1=50; end; outf=kmeans(data1,c1); dlmwrite('$outfolder/leibiebianhao.txt',outf); exit\""); 
if ($status){
	$error_msg = "ERROR! Generate leibiebianhao execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! Generate leibiebianhao execution failed!";
}

#Generate ex and ep1
$status =system("perl $perlpath/genex.pl $outfolder/ep.txt $outfolder/ep1.txt $outfolder/ex.txt"); 
if ($status){
	$error_msg = "ERROR! genex execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! genex execution failed!";
}

#Get idnewnew
$status =system("perl $perlpath/findidnewnew.pl $outfolder/idnew.txt $outfolder/ex.txt $outfolder/idnewnew.txt"); 
if ($status){
	$error_msg = "ERROR! findidnewnew execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! findidnewnew execution failed!";
}

#Insert leibiebianhao into ep1
$status =system("perl $perlpath/insertLeibiebianhao.pl $outfolder/ep1.txt $outfolder/leibiebianhao.txt $outfolder/ep1new.txt"); 
if ($status){
	$error_msg = "ERROR! insertLeibiebianhao execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! insertLeibiebianhao execution failed!";
}

#Generate de_profile
$status =system("perl $perlpath/gendeprofile.pl $outfolder/ep1new.txt $outfolder/idnewnew.txt $outfolder/de_profile.txt"); 
if ($status){
	$error_msg = "ERROR! gendeprofile execution failed!";
	@i1=split(/\//,$outfolder);
	$id=$i1[4];
	$email=substr($id,0,index($id,"_"));
	$UniqueID=substr($id,index($id,"_")+1);
	system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
	die "ERROR! gendeprofile execution failed!";
}

#check is de_profile.txt is empty
open(FILE1, "$outfolder/de_profile.txt") || die("Couldn't read file $outfolder/de_profile.txt\n"); 
@a1=<FILE1>;
close FILE1;

$c=0;
foreach $line (@a1) {
	chomp($line);
	$c++;
}

if ($c>=1) {
	#Build gene regulatory networks
	#no header in input files (remove the 1st line from de_profile, ep)
	#input: de_profile, ep, idnew, idnewnew
	#output: new_profile, function_id, corrscore, a, b, pictures
	$log2=$outfolder."/networks.log";
	$status =system("/usr/local/MATLAB/R2013a/bin/matlab -nodesktop -nodisplay -nosplash -logfile $log2 -r \"addpath('$matlabpath'); de_profile = dlmread('$outfolder/de_profile.txt'); ep = dlmread('$outfolder/ep1new.txt'); idnew = importdata('$outfolder/idnew.txt'); idnewnew = dlmread('$outfolder/idnewnew.txt'); nc = size(de_profile,2); if nc<=4 exit; elseif nc<=5 c1=2; else c1=3; end; new_profile = kmeans_for_new_profile(de_profile,ep); [a,b]=treeTraining4All(ep,new_profile,c1); k=dataforperl(a); corrscore=correlationAnalysis(a); dlmwrite('$outfolder/function_id.txt',k,'\t'); dlmwrite('$outfolder/corrscore.txt',corrscore,'\t'); save('$outfolder/new_profile.mat','new_profile'); save('$outfolder/a.mat','a'); save('$outfolder/b.mat','b'); ans=draw(ep,a,idnewnew,idnew); dlmwrite('$outfolder/ans.txt',ans,'\t'); exit\""); 
	if ($status){
		$error_msg = "ERROR! Build gene regulatory networks execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! Build gene regulatory networks execution failed!";
	}

	#move pictures
	`mkdir $outfolder/Module_figures`;
	`mv $outfolder/*.jpeg $outfolder/Module_figures/`;

	`tar cvf Module_figures.tar Module_figures`;
	`gzip Module_figures.tar`;

	#Get function_idnew
	$status =system("perl $perlpath/getfunctionidnew.pl $outfolder/function_id.txt $outfolder/ex.txt $outfolder/function_idnew.txt"); 
	if ($status){
		$error_msg = "ERROR! getfunctionidnew execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! getfunctionidnew execution failed!";
	}

	#Construct pathway functions
	`mkdir $outfolder/pathway`;

	$status =system("perl $perlpath/module100get_function.pl $outfolder/function_idnew.txt $function_result $outfolder/pathway"); 
	if ($status){
		$error_msg = "ERROR! module100get_function execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! module100get_function execution failed!";
	}

	$status =system("perl $perlpath/module100get_function1.pl $function_result $perlpath/go.fasta $outfolder/pathway $perlpath"); 
	if ($status){
		$error_msg = "ERROR! module100get_function1 execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! module100get_function1 execution failed!";
	}

	$status =system("perl $perlpath/handleclearoutresultfunctionGo.pl $outfolder/pathway"); 
	if ($status){
		$error_msg = "ERROR! handleclearoutresultfunctionGo execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! handleclearoutresultfunctionGo execution failed!";
	}

	$status =system("perl $perlpath/AnnotationTable.pl $outfolder/function_idnew.txt $outfolder/pathway"); 
	if ($status){
		$error_msg = "ERROR! AnnotationTable execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! AnnotationTable execution failed!";
	}

	$status =system("perl $perlpath/chisquareclearoutEnrithmentScore.pl $outfolder/pathway"); 
	if ($status){
		$error_msg = "ERROR! chisquareclearoutEnrithmentScore execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! chisquareclearoutEnrithmentScore execution failed!";
	}

	$status =system("perl $perlpath/matlabAnnotationtable.pl $outfolder/pathway"); 
	if ($status){
		$error_msg = "ERROR! matlabAnnotationtable execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! matlabAnnotationtable execution failed!";
	}

	`cp $outfolder/corrscore.txt $outfolder/network_corrscore.txt`;

	`cp $outfolder/pathway/clearoutEnrithmentScore.txt $outfolder/pathway/network_EnrithmentScore.txt`;

	$status =system("perl $perlpath/findModuleGeneName.pl $outfolder/function_idnew.txt $id2name $outfolder/network_genes.txt"); 
	if ($status){
		$error_msg = "ERROR! findModuleGeneName.pl execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! findModuleGeneName.pl execution failed!";
	}

	$status =system("perl $perlpath/findModuleGeneName2.pl $outfolder/ans.txt $id2name $outfolder/ex.txt $outfolder/ansnew.txt"); 
	if ($status){
		$error_msg = "ERROR! findModuleGeneName.pl execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! findModuleGeneName.pl execution failed!";
	}

	$status =system("perl $perlpath/Rdrawnetwork.pl $outfolder/network_genes.txt $outfolder/ansnew.txt $outfolder"); 
	if ($status){
		$error_msg = "ERROR! Rdrawnetwork.pl execution failed!";
		@i1=split(/\//,$outfolder);
		$id=$i1[4];
		$email=substr($id,0,index($id,"_"));
		$UniqueID=substr($id,index($id,"_")+1);
		system("perl /var/www/html/rnaminer/RNAFunctions/Mail_error_to_admin.pl $email $UniqueID \"$error_msg\"");
		die "ERROR! Rdrawnetwork.pl execution failed!";
	}
}

