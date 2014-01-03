//API example
var test = function(){
  var lp = MAKE_SOLVER();
  lp.set_name("sample");
  lp.set_obj_dir(GLPK.max);
  lp.add_rows(3);
  lp.add_cols(3);
  lp.set_row_name(1, "p");
  lp.set_row_name(2, "q");
  lp.set_row_name(3, "r");
  lp.set_row_bnds(1, GLPK.up, 0.0, 100.0);
  lp.set_row_bnds(2, GLPK.up, 0.0, 600.0);
  lp.set_row_bnds(3, GLPK.up, 0.0, 300.0);
  lp.set_col_name(1, "x1");
  lp.set_col_name(2, "x2");
  lp.set_col_name(3, "x3");
  lp.set_col_bnds(1, GLPK.lo, 0.0, 0.0);
  lp.set_col_bnds(2, GLPK.lo, 0.0, 0.0);
  lp.set_col_bnds(3, GLPK.lo, 0.0, 0.0);
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
