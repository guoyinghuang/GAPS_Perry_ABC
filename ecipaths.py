import os

klmshare_path = os.environ['klmshare']

os.chdir(klmshare_path)
os.chdir("ERC_Projects")
os.chdir("ecipop"); ecipop_path = os.getcwd()

os.chdir("ABC"); abc_path = os.getcwd()
os.chdir("data"); abcdata_path = os.getcwd()
os.chdir("intermediary"); abcdataintermediary_path = os.getcwd()
os.chdir(".."); os.chdir("raw"); abcdataraw_path = os.getcwd()
os.chdir(".."); os.chdir("refined"); abcdatarefined_path = os.getcwd()
os.chdir(abc_path); os.chdir("dofiles"); abcdofile_path = os.getcwd()

os.chdir(ecipop_path); os.chdir("Perry"); perry_path = os.getcwd()
os.chdir("Data"); perrydata_path = os.getcwd(); 
os.chdir("Raw"); perrydataraw_path = os.getcwd()
os.chdir(perry_path); os.chdir("DoFiles"); perrydofile_path = os.getcwd()

os.chdir(ecipop_path); os.chdir("Write-up"); writeup_path = os.getcwd()

pathdict = {'klmshare_path': klmshare_path, 'ecipop_path':ecipop_path, 
'abc_path':abc_path, 'abcdata_path':abcdata_path, 
'abcdataintermediary_path':abcdataintermediary_path, 'abcdataraw_path':abcdataraw_path, 
'abcdatarefined_path':abcdatarefined_path, 'abcdofile_path':abcdofile_path, 
'perry_path':perry_path, 'perrydata_path':perrydata_path, 
'perrydataraw_path':perrydataraw_path, 'perrydofile_path':perrydofile_path, 
'writeup_path':writeup_path}

def getPaths():
    maxkey = max([len(key) for key in pathdict.keys()])
    path_list = pathdict.items()
    path_list = [(path[1], path[0]) for path in path_list]
    path_list.sort()
    
    for pair in path_list:
        path = pair[0]
        key = pair[1]
        diff_length = maxkey - len(key)
        print key + ' '*diff_length, "=", path	
