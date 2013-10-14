function performance = mturk_checkperformance(adata)

  % get performance
  nb_indices = adata.numbers.indices;
  performance = [];
  i = 0;
  ii_subject = 0;
  while ii_subject(end) < length(adata.sdata.resp_correct)
    ii_subject = (i*nb_indices+1):((i+1)*nb_indices);
    ii_subject_first = ceil((i+.5) * nb_indices);
    ii_subject_last  = ceil((i+ 1) * nb_indices);
    ii_subject = ii_subject_first:ii_subject_last;
    performance(end+1) = mean(adata.sdata.resp_correct(ii_subject));
    i = i+1;
  end

  % plot performance
  hist(performance,0.0:.05:1);
  
end