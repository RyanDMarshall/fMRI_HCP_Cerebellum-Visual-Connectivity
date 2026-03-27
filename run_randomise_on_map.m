function [] = run_randomise_on_map(fname)
    run_bash_path=fullfile(pwd,'run_randomise_on_map.sh');
    cmdstr=[run_bash_path ' ' fname];
    sprintf(cmdstr);
    system(sprintf(cmdstr));
end