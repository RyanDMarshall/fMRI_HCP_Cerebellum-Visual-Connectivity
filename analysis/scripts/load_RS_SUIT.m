% Extract all cdata matrices from a sesssion-run set
function [inner_cdata, mid_cdata, outer_cdata] = load_RS_SUIT(session,run)
    rest_dir = '/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest';
    scan_dir = sprintf('%s/%s/rest/%03d/',rest_dir,session,run);

    inner_fn = [scan_dir, 'f.mcpr.sc.int.bpf.residMGSR.inner.SUIT.func.gii'];
    mid_fn = replace(inner_fn,'inner','mid');
    outer_fn = replace(inner_fn,'inner','outer');

    inner_gii = gifti(inner_fn); mid_gii = gifti(mid_fn); outer_gii = gifti(outer_fn);
    inner_cdata = inner_gii.cdata; mid_cdata = mid_gii.cdata; outer_cdata = outer_gii.cdata;
end