//TODO as post-js during the compilation
var GLPK = (function () {
    return {
        glp_create_prob   : Module.cwrap('glp_create_prob',   'number', []),
        glp_delete_prob   : Module.cwrap('glp_delete_prob',   'number', ['number']),
        glp_erase_prob    : Module.cwrap('glp_erase_prob',    'number', ['number']),
        glp_set_prob_name : Module.cwrap('glp_set_prob_name', 'number', ['number', 'string']),
        glp_get_prob_name : Module.cwrap('glp_get_prob_name', 'string', ['number']),
        glp_set_obj_dir   : Module.cwrap('glp_set_obj_dir',   'number', ['number', 'number']),
        glp_add_rows      : Module.cwrap('glp_add_rows',      'number', ['number', 'number']),
        glp_set_row_name  : Module.cwrap('glp_set_row_name',  'number', ['number', 'number', 'string']),
        glp_set_row_bnds  : Module.cwrap('glp_set_row_bnds',  'number', ['number', 'number', 'number', 'number', 'number']),
        glp_add_cols      : Module.cwrap('glp_add_cols',      'number', ['number', 'number']),
        glp_set_col_name  : Module.cwrap('glp_set_col_name',  'number', ['number', 'number', 'string']),
        glp_set_col_bnds  : Module.cwrap('glp_set_col_bnds',  'number', ['number', 'number', 'number', 'number', 'number']),
        glp_set_obj_coef  : Module.cwrap('glp_set_obj_coef',  'number', ['number', 'number', 'number']),
        glp_load_matrix   : Module.cwrap('glp_load_matrix',   'number', ['number', 'number', 'number', 'number', 'number']),
        glp_simplex       : Module.cwrap('glp_simplex',       'number', ['number', 'number']),
        glp_exact         : Module.cwrap('glp_exact',         'number', ['number', 'number']),
        glp_interior      : Module.cwrap('glp_interior',      'number', ['number', 'number']),
        glp_intopt        : Module.cwrap('glp_intopt',        'number', ['number', 'number']),
        glp_get_obj_val   : Module.cwrap('glp_get_obj_val',   'number', ['number']),
        glp_get_col_prim  : Module.cwrap('glp_get_col_prim',  'number', ['number', 'number']),
        glp_del_cols      : Module.cwrap('glp_del_cols',      'number', ['number', 'number', 'number']),
        glp_del_rows      : Module.cwrap('glp_del_rows',      'number', ['number', 'number', 'number']),
        glp_set_mat_col   : Module.cwrap('glp_set_mat_col',   'number', ['number', 'number', 'number', 'number', 'number']),
        glp_set_mat_row   : Module.cwrap('glp_set_mat_row',   'number', ['number', 'number', 'number', 'number', 'number']),
        glp_get_col_lb    : Module.cwrap('glp_get_col_lb',    'number', ['number', 'number']),
        glp_get_col_ub    : Module.cwrap('glp_get_col_ub',    'number', ['number', 'number']),
        glp_get_row_lb    : Module.cwrap('glp_get_row_lb',    'number', ['number', 'number']),
        glp_get_row_ub    : Module.cwrap('glp_get_row_ub',    'number', ['number', 'number']),
        glp_get_col_bind  : Module.cwrap('glp_get_col_bind',  'number', ['number', 'number']),
        glp_get_row_bind  : Module.cwrap('glp_get_row_bind',  'number', ['number', 'number']),
        glp_get_col_dual  : Module.cwrap('glp_get_col_dual',  'number', ['number', 'number']),
        glp_get_row_dual  : Module.cwrap('glp_get_row_dual',  'number', ['number', 'number']),
        glp_get_col_name  : Module.cwrap('glp_get_col_name',  'string', ['number', 'number']),
        glp_get_row_name  : Module.cwrap('glp_get_row_name',  'string', ['number', 'number']),
        glp_get_col_stat  : Module.cwrap('glp_get_col_stat',  'number', ['number', 'number']),
        glp_get_row_stat  : Module.cwrap('glp_get_row_stat',  'number', ['number', 'number']),
        glp_get_col_type  : Module.cwrap('glp_get_col_type',  'number', ['number', 'number']),
        glp_get_row_type  : Module.cwrap('glp_get_row_type',  'number', ['number', 'number']),
        glp_get_col_kind  : Module.cwrap('glp_get_col_kind',  'number', ['number', 'number']),
        glp_get_row_prim  : Module.cwrap('glp_get_row_prim',  'number', ['number', 'number']), 
        glp_term_out      : Module.cwrap('glp_term_out',      'number', ['number', 'number'])
//      glp_bf_exists     : Module.cwrap('glp_bf_exists',     'number', ['number', 
//      glp_bf_updated    : Module.cwrap('glp_bf_updated',    'number', ['number', 
//      glp_cpx_basis     : Module.cwrap('glp_cpx_basis',     'number', ['number', 
//      glp_factorize     : Module.cwrap('glp_factorize',     'number', ['number', 
//      glp_get_dual_stat : Module.cwrap('glp_get_dual_stat', 'number', ['number', 
//      glp_get_mat_col   : Module.cwrap('glp_get_mat_col',   'number', ['number', 
//      glp_get_mat_row   : Module.cwrap('glp_get_mat_row',   'number', ['number', 
//      glp_get_num_bin   : Module.cwrap('glp_get_num_bin',   'number', ['number', 
//      glp_get_num_cols  : Module.cwrap('glp_get_num_cols',  'number', ['number', 
//      glp_get_num_int   : Module.cwrap('glp_get_num_int',   'number', ['number', 
//      glp_get_num_nz    : Module.cwrap('glp_get_num_nz',    'number', ['number', 
//      glp_get_num_rows  : Module.cwrap('glp_get_num_rows',  'number', ['number', 
//      glp_get_obj_coef  : Module.cwrap('glp_get_obj_coef',  'number', ['number', 
//      glp_get_obj_dir   : Module.cwrap('glp_get_obj_dir',   'number', ['number', 
//      glp_get_obj_name  : Module.cwrap('glp_get_obj_name',  'string', ['number', 
//      glp_get_prim_stat : Module.cwrap('glp_get_prim_stat', 'number', ['number', 
//      glp_get_rii       : Module.cwrap('glp_get_rii',       'number', ['number', 
//      glp_get_sjj       : Module.cwrap('glp_get_sjj',       'number', ['number', 
//      glp_get_status    : Module.cwrap('glp_get_status',    'number', ['number', 
//      glp_get_unbnd_ray : Module.cwrap('glp_get_unbnd_ray', 'number', ['number', 
//      glp_init_cpxcp    : Module.cwrap('glp_init_cpxcp',    'number', ['number', 
//      glp_init_iocp     : Module.cwrap('glp_init_iocp',     'number', ['number', 
//      glp_init_iptcp    : Module.cwrap('glp_init_iptcp',    'number', ['number', 
//      glp_init_mpscp    : Module.cwrap('glp_init_mpscp',    'number', ['number', 
//      glp_init_smcp     : Module.cwrap('glp_init_smcp',     'number', ['number', 
//      glp_ios_add_row   : Module.cwrap('glp_ios_add_row',   'number', ['number', 
//      glp_ios_best_node : Module.cwrap('glp_ios_best_node', 'number', ['number', 
//      glp_ios_branch_upon : Module.cwrap('glp_ios_branch_upon', 'number', ['number', 
//      glp_ios_can_branch : Module.cwrap('glp_ios_can_branch', 'number', ['number', 
//      glp_ios_clear_pool : Module.cwrap('glp_ios_clear_pool', 'number', ['number', 
//      glp_ios_curr_node : Module.cwrap('glp_ios_curr_node', 'number', ['number', 
//      glp_ios_del_row   : Module.cwrap('glp_ios_del_row',   'number', ['number', 
//      glp_ios_get_prob  : Module.cwrap('glp_ios_get_prob',
//      glp_ios_heur_sol  : Module.cwrap('glp_ios_heur_sol',
//      glp_ios_mip_gap   : Module.cwrap('glp_ios_mip_gap',
//      glp_ios_next_node : Module.cwrap('glp_ios_next_node',
//      glp_ios_node_bound : Module.cwrap('glp_ios_node_bound',
//      glp_ios_node_data : Module.cwrap('glp_ios_node_data',
//      glp_ios_node_level : Module.cwrap('glp_ios_node_level',
//      glp_ios_pool_size : Module.cwrap('glp_ios_pool_size',
//      glp_ios_prev_node : Module.cwrap('glp_ios_prev_node',
//      glp_ios_reason    : Module.cwrap('glp_ios_reason',
//      glp_ios_row_attr  : Module.cwrap('glp_ios_row_attr',
//      glp_ios_select_node : Module.cwrap('glp_ios_select_node',
//      glp_ios_terminate : Module.cwrap('glp_ios_terminate',
//      glp_ios_tree_size : Module.cwrap('glp_ios_tree_size',
//      glp_ios_up_node   : Module.cwrap('glp_ios_up_node',
//      glp_ipt_col_dual  : Module.cwrap('glp_ipt_col_dual',
//      glp_ipt_col_prim  : Module.cwrap('glp_ipt_col_prim',
//      glp_ipt_obj_val   : Module.cwrap('glp_ipt_obj_val',
//      glp_ipt_row_dual  : Module.cwrap('glp_ipt_row_dual',
//      glp_ipt_row_prim  : Module.cwrap('glp_ipt_row_prim',
//      glp_ipt_status    : Module.cwrap('glp_ipt_status',
//      glp_mip_col_val   : Module.cwrap('glp_mip_col_val',
//      glp_mip_obj_val   : Module.cwrap('glp_mip_obj_val',
//      glp_mip_row_val   : Module.cwrap('glp_mip_row_val',
//      glp_mip_status    : Module.cwrap('glp_mip_status',
//      glp_prim_rtest    : Module.cwrap('glp_prim_rtest',
//      glp_scale_prob    : Module.cwrap('glp_scale_prob',
//      glp_set_bfcp      : Module.cwrap('glp_set_bfcp',
//      glp_set_col_kind  : Module.cwrap('glp_set_col_kind',
//      glp_set_col_stat  : Module.cwrap('glp_set_col_stat',
//      glp_set_obj_name  : Module.cwrap('glp_set_obj_name',
//      glp_set_rii       : Module.cwrap('glp_set_rii',
//      glp_set_row_stat  : Module.cwrap('glp_set_row_stat',
//      glp_set_sjj       : Module.cwrap('glp_set_sjj',
//      glp_sort_matrix   : Module.cwrap('glp_sort_matrix',
//      glp_std_basis     : Module.cwrap('glp_std_basis',
//      glp_transform_col : Module.cwrap('glp_transform_col',
//      glp_transform_row : Module.cwrap('glp_transform_row',
//      glp_unscale_prob  : Module.cwrap('glp_unscale_prob',
//      glp_warm_up       : Module.cwrap('glp_warm_up',
    };
})()

/* optimization direction flag: */
var glp_dir = {
    min: 1,
    max: 2
}

/* kind of structural variable: */
var glp_kind = {
  cv: 1, /* continuous variable */
  iv: 2,  /* integer variable */
  bv: 3.  /* binary variable */
}

/* type of auxiliary/structural variable: */
var glp_aux = {
    fr: 1, /* free (unbounded) variable */
    lo: 2, /* variable with lower bound */
    up: 3, /* variable with upper bound */
    db: 4, /* double-bounded variable */
    fx: 5  /* fixed variable */
}

/* status of auxiliary/structural variable: */
var glp_stat = {
    bs: 1, /* basic variable */
    nl: 2, /* non-basic variable on lower bound */
    nu: 3, /* non-basic variable on upper bound */
    nf: 4, /* non-basic free (unbounded) variable */
    ns: 5  /* non-basic fixed variable */
}
    
//  /* scaling options: */
//  #define GLP_SF_GM       0x01  /* perform geometric mean scaling */
//  #define GLP_SF_EQ       0x10  /* perform equilibration scaling */
//  #define GLP_SF_2N       0x20  /* round scale factors to power of two */
//  #define GLP_SF_SKIP     0x40  /* skip if problem is well scaled */
//  #define GLP_SF_AUTO     0x80  /* choose scaling options automatically */

/* solution indicator: */
var glp_sol_kind = {
    sol: 1, /* basic solution */
    ipt: 2, /* interior-point solution */
    mip: 3  /* mixed integer solution */
}

/* solution status: */
var glp_sol_stat = {
    undef : 1, /* solution is undefined */
    feas  : 2, /* solution is feasible */
    infeas: 3, /* solution is infeasible */
    nofeas: 4, /* no feasible solution exists */
    opt   : 5, /* solution is optimal */
    unbnd : 6  /* solution is unbounded */
}

var glp_term = {
    off: 0, /* no output */
    err: 1, /* warning and error messages only */
    on : 2, /* normal output */
    all: 3, /* full output */
    dbg: 4  /* debug output */
}

//TODO make a solver module that simplify the paramters ...
var MAKE_SOLVER = function(){

//TODO arrays:
// https://github.com/kripken/emscripten/wiki/Interacting-with-code#accessing-memory
// https://github.com/kripken/zee.js/blob/master/post.js
// http://webcheatsheet.com/javascript/arrays.php
// TODO use type arrays ?

  var pb = GLPK.glp_create_prob();
  GLPK.glp_term_out(glp_term.off);

  return {
      free : function(){ GLPK.glp_delete_prob(pb); },
      erase : function(){ GLPK.glp_erase_prob(pb); },

      set_name: function(name){ GLPK.glp_set_prob_name(pb, name); },
      get_name: function(){ GLPK.glp_get_prob_name(pb); },

      set_obj_dir: function(dir){ GLPK.glp_set_obj_dir(pb, dir); },
      set_obj_coeff: function(idx, coeff){ GLPK.glp_set_obj_coef(pb, idx, coeff); },

      add_rows: function(nbr){ GLPK.glp_add_rows(pb, nbr); },
      set_row_bnds: function(idx, dir, lb, ub){ GLPK.glp_set_row_bnds(pb, idx, dir, lb, ub); },
      set_row_name: function(idx, name){ GLPK.glp_set_row_name(pb, idx, name); },

      add_cols: function(nbr){ GLPK.glp_add_cols(pb, nbr); },
      set_col_bnds: function(idx, dir, lb, ub){ GLPK.glp_set_col_bnds(pb, idx, dir, lb, ub); },
      set_col_name: function(idx, name){ GLPK.glp_set_col_name(pb, idx, name); },

      load_matrix: function(size, xs, ys, cs){
          var _xs = Module._malloc(4 * (size + 1));
          var _ys = Module._malloc(4 * (size + 1));
          var _cs = Module._malloc(8 * (size + 1));
          for (var i = 1; i <= size; i++) {
            setValue(_xs + i*4, xs[i], 'i32');
            setValue(_ys + i*4, ys[i], 'i32');
            setValue(_cs + i*8, cs[i], 'double');
          }
          GLPK.glp_load_matrix(pb, size, _xs, _ys, _cs);
          Module._free(_xs);
          Module._free(_ys);
          Module._free(_cs);
      },

      simplex: function(){ return GLPK.glp_simplex(pb, 0); },
      exact: function(){ return GLPK.glp_exact(pb, 0); },
      interior: function(){ return GLPK.glp_interior(pb, 0); },

      get_obj_val: function(){ return GLPK.glp_get_obj_val(pb); },
      get_col_prim: function(idx){ return GLPK.glp_get_col_prim(pb, idx); },

      term_out: function(out){ return GLPK.glp_term_out(pb, out); }
  };

}

//API example
var test = function(){
  var lp = MAKE_SOLVER();
  lp.set_name("sample");
  lp.set_obj_dir(glp_dir.max);
  lp.add_rows(3);
  lp.add_cols(3);
  lp.set_row_name(1, "p");
  lp.set_row_name(2, "q");
  lp.set_row_name(3, "r");
  lp.set_row_bnds(1, glp_aux.up, 0.0, 100.0);
  lp.set_row_bnds(2, glp_aux.up, 0.0, 600.0);
  lp.set_row_bnds(3, glp_aux.up, 0.0, 300.0);
  lp.set_col_name(1, "x1");
  lp.set_col_name(2, "x2");
  lp.set_col_name(3, "x3");
  lp.set_col_bnds(1, glp_aux.lo, 0.0, 0.0);
  lp.set_col_bnds(2, glp_aux.lo, 0.0, 0.0);
  lp.set_col_bnds(3, glp_aux.lo, 0.0, 0.0);
  lp.set_obj_coeff(1, 10.0);
  lp.set_obj_coeff(2,  6.0);
  lp.set_obj_coeff(3,  4.0);
  var ia = new Int32Array(10);
  var ja = new Int32Array(10);
  var ar = new Float64Array(10);
  ia[1] = 1; ja[1] = 1; ar[1] =  1.0; /* a[1,1] =  1 */
  ia[2] = 1; ja[2] = 2; ar[2] =  1.0; /* a[1,2] =  1 */
  ia[3] = 1; ja[3] = 3; ar[3] =  1.0; /* a[1,3] =  1 */
  ia[4] = 2; ja[4] = 1; ar[4] = 10.0; /* a[2,1] = 10 */
  ia[5] = 3; ja[5] = 1; ar[5] =  2.0; /* a[3,1] =  2 */
  ia[6] = 2; ja[6] = 2; ar[6] =  4.0; /* a[2,2] =  4 */
  ia[7] = 3; ja[7] = 2; ar[7] =  2.0; /* a[3,2] =  2 */
  ia[8] = 2; ja[8] = 3; ar[8] =  5.0; /* a[2,3] =  5 */
  ia[9] = 3; ja[9] = 3; ar[9] =  6.0; /* a[3,3] =  6 */
  lp.load_matrix(9, ia, ja, ar);
  lp.simplex();
  var z = lp.get_obj_val();
  var x1 = lp.get_col_prim(1);
  var x2 = lp.get_col_prim(2);
  var x3 = lp.get_col_prim(3);
  lp.free();
  return "z = " + z + "; x1 = " + x1 + "; x2 = " + x2 + "; x3 = " + x3;
}

var run_test = function() {
  var res = test();
  document.getElementById("txt").innerHTML = res;
}
