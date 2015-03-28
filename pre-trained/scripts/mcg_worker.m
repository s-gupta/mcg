function [dt, ucm2] = mcg_worker(in_file_name, mcg_out_file_name, ucm_out_file_name, mode)
% function [dt, ucm2] = mcg_worker(in_file_name, mcg_out_file_name, ucm_out_file_name, mode)

  I = imread(in_file_name);
  [dt, ucm2] = im2mcg(I, mode);

  % Convert to a better format
  sp2reg = false(size(dt.labels,1), max(dt.superpixels(:)));
  for i = 1:length(dt.labels), 
    sp2reg(i, dt.labels{i}) = true;
  end
  dt = rmfield(dt, 'labels');
  dt.sp2reg = sp2reg;
  dt.bboxes = single(dt.bboxes);

  if(~isempty(mcg_out_file_name)), save(mcg_out_file_name, '-struct', 'dt'); end
  if(~isempty(ucm_out_file_name)), save(ucm_out_file_name, 'ucm2'); end
end
