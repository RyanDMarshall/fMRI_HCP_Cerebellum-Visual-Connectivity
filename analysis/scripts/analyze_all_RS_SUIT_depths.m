rest_dir = '/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest';
out_dir = sprintf('%s/results_RS_SUIT', rest_dir);

sessidfn = sprintf('%s/sessid_all_sessions',rest_dir);
sessid = fileread(sessidfn);

sessions = strsplit(sessid,'\n');

inner_cdata_all = [];
mid_cdata_all = [];
outer_cdata_all = [];

for i = 1:length(sessions)
    sess = sessions{i};
    runfn = sprintf('%s/%s/rest/runlist',rest_dir,sess);
    runs = strsplit(fileread(runfn));
    runs = runs(~cellfun('isempty',runs));
    
    for j = 1:length(runs)
        run = str2num(runs{j});
        %[inner_cdata(i,j,:), mid_cdata(i,j,:), outer_cdata(i,j,:)] = 
        fprintf('Viewing RS SUIT depths - session %s run %03d\n', sess, run)
        [inner_cdata_sr, mid_cdata_sr, outer_cdata_sr] = analyze_RS_SUIT_depths(sess,run,out_dir);
        inner_cdata_all = [inner_cdata_all, inner_cdata_sr];
        mid_cdata_all = [mid_cdata_all, mid_cdata_sr];
        outer_cdata_all = [outer_cdata_all, outer_cdata_sr];
 
    end

    test = 1;

    close all;
end