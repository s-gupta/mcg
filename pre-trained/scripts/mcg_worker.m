function [dt, ucm2] = mcg_worker(in_file_name, mcg_out_file_name, ...
  ucm_out_file_name, mode, crop, resize)
% function [dt, ucm2] = mcg_worker(in_file_name, mcg_out_file_name,
% ucm_out_file_name, mode, crop, resize)
  if nargin < 5, crop = []; end
  if nargin < 6,resize = 1; end

  I = imread(in_file_name);
  if ~isempty(crop),
    Icrop = I(crop(1):crop(3), crop(2):crop(4), :);
  else,
    Icrop = I;
  end

  if resize ~= 1,
    Iresize = imresize(Icrop, resize);
  else,
    Iresize = Icrop;
  end

  disp(size(Iresize))
  [dt, ucm2] = im2mcg(Iresize, mode);

  % Convert to a better format
  sp2reg = false(size(dt.labels,1), max(dt.superpixels(:)));
  for i = 1:length(dt.labels), 
    sp2reg(i, dt.labels{i}) = true;
  end
  
  % Undo the transforms
  if resize ~= 1,
    dt.sp = imresize(dt.sp, [size(Icrop,1), size(Icrop,2)], 'nearest')
  end

  if ~isempty(crop),
    % Pad sp by the right amounts.
    sp = dt.superpixels;
    val = max(sp(:)) + 1;
    sp = padarray(sp, [crop(1)-1, crop(2)-1], val, 'pre');
    sp = padarray(sp, [size(I,1)-crop(3), size(I,2)-crop(4)], val, 'post');
    sp2reg(:,end+1) = false;
    dt.bboxes(:,1) = dt.bboxes(:,1) + crop(1)-1;
    dt.bboxes(:,2) = dt.bboxes(:,2) + crop(2)-1;
  end

  dt = rmfield(dt, 'labels');
  dt.sp2reg = sp2reg;
  dt.bboxes = single(dt.bboxes);

  if(~isempty(mcg_out_file_name)), save(mcg_out_file_name, '-struct', 'dt'); end
  if(~isempty(ucm_out_file_name)), save(ucm_out_file_name, 'ucm2'); end
end
