function script_mcg_run(in_dir, out_dir, imlist, mode, save_mcg, save_ucm)
% function script_mcg_run(in_dir, out_dir, imlist, mode, save_mcg, save_ucm)

  for i = 1:length(imlist),
    mcg_out_file_name = sprintf('%s/mcg/%s.mat', out_dir, imlist{i});
    ucm_out_file_name = sprintf('%s/ucm/%s.mat', out_dir, imlist{i});
    if(~save_mcg), 
      mcg_out_file_name = []; 
    else
      [a, ~, ~] = fileparts(mcg_out_file_name);
      if(exist(a, 'dir') == 0), mkdir(a); end
    end

    if(~save_ucm), 
      ucm_out_file_name = []; 
    else, 
      [a, ~, ~] = fileparts(ucm_out_file_name);
      if(exist(a, 'dir') == 0), mkdir(a); end
    end

    args{i} = {sprintf('%s/%s.jpg', in_dir, imlist{i}), ...
      mcg_out_file_name, ucm_out_file_name, mode};
  end
  
  my_dir = fileparts(which(mfilename));

  jobParam = struct('numThreads', 1, 'codeDir', my_dir, 'preamble', '', 'matlabpoolN', 1, 'globalVars', {{}}, 'fHandle', @mcg_worker, 'numOutputs', 0);
  resourceParam = struct('mem', 4, 'hh', 24, 'numJobs', 50, 'ppn', 1, 'nodes', 1, 'logDir', fullfile(my_dir, 'logs'), 'queue', 'psi', 'notif', false, 'username', 'sgupta', 'headNode', 'zen');

  [jobId jobDir] = jobParallel('mcg', resourceParam, jobParam, args);
end
