% Returns run-concatenated data from all sessions

rest_dir = '/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest';
out_dir = sprintf('%s/results_RS_SUIT', rest_dir);

sessidfn = sprintf('%s/sessid_all_sessions',rest_dir);
sessid = fileread(sessidfn);

sessions = strsplit(sessid,'\n');

% Load in all data on parallel pool
%delete(gcp('nocreate'))
%parpool(6)

%par
inner_cdata = {}; mid_cdata={}; outer_cdata = {};
parfor i = 1:length(sessions)
    sess = sessions{i};
    runfn = sprintf('%s/%s/rest/runlist',rest_dir,sess);

    runs = strsplit(fileread(runfn));
    runs = runs(~cellfun('isempty',runs));

    for j = 1:length(runs)
        run = str2num(runs{j});
        fprintf('Loading SUIT gii cdata from session %s run %03d\n', sess, run)

        %[inner_cdata(i,j,:), mid_cdata(i,j,:), outer_cdata(i,j,:)] = 
        [inner_cdata{i,j}, mid_cdata{i,j}, outer_cdata{i,j}] = load_RS_SUIT(sess,run);
    end
end

%% Concatenate runs

for i = 1:length(sessions)
    outer_cdata_cat{i} = [inner_cdata{i,:}];
    mid_cdata_cat{i} = [mid_cdata{i,:}];
    inner_cdata_cat{i} = [outer_cdata{i,:}];
end
save('workspace.mat')


%% Analyze
for i = 1:length(sessions)
    sess = sessions{i};
    inner_cdata_sess = inner_cdata_cat{i};
    mid_cdata_sess = mid_cdata_cat{i};
    outer_cdata_sess = outer_cdata_cat{i};

    mean_cdata_cat{i} = (inner_cdata_sess + mid_cdata_sess + outer_cdata_sess) ./ 3;
    mean_cdata_sess = mean_cdata_cat{i};

    view_flatmap({inner_cdata_sess,mid_cdata_sess,outer_cdata_sess,mean_cdata_sess}, ...
                 'save', sprintf('%s\_depths\_timeseries.gif',sess),'results','subplot',[4 1]);
end

