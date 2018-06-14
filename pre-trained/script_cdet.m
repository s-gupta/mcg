if false,
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
end

if true,
  base_dir = '/global/scratch/saurabhg/clutter-det/primesense';
  run_name = 'mcg_crop';
  mkdir(fullfile(base_dir, run_name));
  out_img_dir = fullfile(base_dir, 'mcg_crop', 'crop_resize_images');
  mkdir(out_img_dir);
  for mode = {'fast', 'accurate'},
    img_dir = fullfile(base_dir, 'color_ims');
    mcg_dir = fullfile(base_dir, 'mcg_crop', mode{1});
    mkdir(mcg_dir);

    parfor i = 0:119,
      n = sprintf('image_%06d', i);
      img_fn = [fullfile(img_dir, n) '.png']; 
      out_img_fn = [fullfile(out_img_dir, n) '.jpg']; 
      ucm_fn = '';
      mcg_fn = [fullfile(mcg_dir, n) '.mat'];
      crop = [65, 32, 388, 544]; resize = 2;
      mcg_worker(img_fn, mcg_fn, ucm_fn, out_img_fn, mode{1}, crop, resize);
      disp(i)
    end
  end
end
