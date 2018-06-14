base_dir = '/global/scratch/saurabhg/clutter-det/primesense';
for mode = {'fast', 'accurate'},
  img_dir = fullfile(base_dir, 'color_ims');
  ucm_dir = fullfile(base_dir, mode{1}, 'ucm');
  mcg_dir = fullfile(base_dir, mode{1}, 'mcg');

  for i = 0:119,
    n = sprintf('image_%06d', i);
    img_fn = [fullfile(img_dir, n) '.png']; 
    ucm_fn = [fullfile(ucm_dir, n) '.mat'];
    mcg_fn = [fullfile(mcg_dir, n) '.mat'];
    mcg_worker(img_fn, mcg_fn, ucm_fn, mode{1});
    disp(i)
  end
end
