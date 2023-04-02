/* This file was automatically generated by CasADi.
   The CasADi copyright holders make no ownership claim of its contents. */
#ifdef __cplusplus
extern "C" {
#endif

/* How to prefix internal symbols */
#ifdef CASADI_CODEGEN_PREFIX
  #define CASADI_NAMESPACE_CONCAT(NS, ID) _CASADI_NAMESPACE_CONCAT(NS, ID)
  #define _CASADI_NAMESPACE_CONCAT(NS, ID) NS ## ID
  #define CASADI_PREFIX(ID) CASADI_NAMESPACE_CONCAT(CODEGEN_PREFIX, ID)
#else
  #define CASADI_PREFIX(ID) astrobee_cost_ext_cost_e_fun_jac_ ## ID
#endif

#include <math.h>

#ifndef casadi_real
#define casadi_real double
#endif

#ifndef casadi_int
#define casadi_int int
#endif

/* Add prefix to internal symbols */
#define casadi_c0 CASADI_PREFIX(c0)
#define casadi_clear CASADI_PREFIX(clear)
#define casadi_copy CASADI_PREFIX(copy)
#define casadi_f0 CASADI_PREFIX(f0)
#define casadi_s0 CASADI_PREFIX(s0)
#define casadi_s1 CASADI_PREFIX(s1)
#define casadi_s2 CASADI_PREFIX(s2)
#define casadi_s3 CASADI_PREFIX(s3)

/* Symbol visibility in DLLs */
#ifndef CASADI_SYMBOL_EXPORT
  #if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
    #if defined(STATIC_LINKED)
      #define CASADI_SYMBOL_EXPORT
    #else
      #define CASADI_SYMBOL_EXPORT __declspec(dllexport)
    #endif
  #elif defined(__GNUC__) && defined(GCC_HASCLASSVISIBILITY)
    #define CASADI_SYMBOL_EXPORT __attribute__ ((visibility ("default")))
  #else
    #define CASADI_SYMBOL_EXPORT
  #endif
#endif

void casadi_clear(casadi_real* x, casadi_int n) {
  casadi_int i;
  if (x) {
    for (i=0; i<n; ++i) *x++ = 0;
  }
}

void casadi_copy(const casadi_real* x, casadi_int n, casadi_real* y) {
  casadi_int i;
  if (y) {
    if (x) {
      for (i=0; i<n; ++i) *y++ = *x++;
    } else {
      for (i=0; i<n; ++i) *y++ = 0.;
    }
  }
}

static const casadi_int casadi_s0[16] = {12, 1, 0, 12, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
static const casadi_int casadi_s1[3] = {0, 0, 0};
static const casadi_int casadi_s2[32] = {28, 1, 0, 28, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27};
static const casadi_int casadi_s3[5] = {1, 1, 0, 1, 0};

static const casadi_real casadi_c0[144] = {4.5447331925463963e+01, 0., 0., 9.6000632360892411e+01, 0., 0., -5.6672076873272334e-14, 0., 0., -1.3994858503097251e-15, 0., 0., 0., 4.5447331925462635e+01, 0., 0., 9.6000632360885362e+01, 0., 0., -4.7580418882194603e-14, 0., 0., -1.1678728764420225e-14, 0., 0., 0., 4.5447331925461548e+01, 0., 0., 9.6000632360882491e+01, 0., 0., 3.0278396528136100e-14, 0., 0., 4.1541107317822559e-15, 9.6000632360892411e+01, 0., 0., 4.3199880818351102e+02, 0., 0., -1.2043042187350050e-13, 0., 0., 1.3065113819072846e-14, 0., 0., 0., 9.6000632360885362e+01, 0., 0., 4.3199880818348214e+02, 0., 0., -4.5785586415410353e-14, 0., 0., -3.1044165663922353e-14, 0., 0., 0., 9.6000632360882491e+01, 0., 0., 4.3199880818347549e+02, 0., 0., 1.7512892696740252e-14, 0., 0., -2.3575775415097003e-15, -5.6672076873272334e-14, 0., 0., -1.2043042187350050e-13, 0., 0., 1.2011523240350419e+01, 0., 0., 1.6132583656564552e+00, 0., 0., 0., -4.7580418882194603e-14, 0., 0., -4.5785586415410353e-14, 0., 0., 1.1923126517603416e+01, 0., 0., 1.5118909718587272e+00, 0., 0., 0., 3.0278396528136100e-14, 0., 0., 1.7512892696740252e-14, 0., 0., 1.2084990066039289e+01, 0., 0., 1.6980997415114403e+00, -1.3994858503097251e-15, 0., 0., 1.3065113819072846e-14, 0., 0., 1.6132583656564552e+00, 0., 0., 2.3572791540227636e+00, 0., 0., 0., -1.1678728764420225e-14, 0., 0., -3.1044165663922353e-14, 0., 0., 1.5118909718587272e+00, 0., 0., 2.2272237119943163e+00, 0., 0., 0., 4.1541107317822559e-15, 0., 0., -2.3575775415097003e-15, 0., 0., 1.6980997415114403e+00, 0., 0., 2.4674211649171536e+00};

/* astrobee_cost_ext_cost_e_fun_jac:(i0[12],i1[],i2[],i3[28])->(o0,o1[12]) */
static int casadi_f0(const casadi_real** arg, casadi_real** res, casadi_int* iw, casadi_real* w, int mem) {
  casadi_int i, j, k;
  casadi_real *rr, *ss, *tt;
  const casadi_real *cs;
  casadi_real w0, *w1=w+2, *w2=w+14, *w3=w+26, *w4=w+38, *w5=w+50, *w6=w+62, *w7=w+206;
  /* #0: @0 = 0 */
  w0 = 0.;
  /* #1: @1 = zeros(1x12) */
  casadi_clear(w1, 12);
  /* #2: @2 = input[0][0] */
  casadi_copy(arg[0], 12, w2);
  /* #3: @3 = @2' */
  casadi_copy(w2, 12, w3);
  /* #4: @4 = input[3][0] */
  casadi_copy(arg[3], 12, w4);
  /* #5: @5 = @4' */
  casadi_copy(w4, 12, w5);
  /* #6: @3 = (@3-@5) */
  for (i=0, rr=w3, cs=w5; i<12; ++i) (*rr++) -= (*cs++);
  /* #7: @6 = 
  [[45.4473, 0, 0, 96.0006, 0, 0, -5.66721e-14, 0, 0, -1.39949e-15, 0, 0], 
   [0, 45.4473, 0, 0, 96.0006, 0, 0, -4.75804e-14, 0, 0, -1.16787e-14, 0], 
   [0, 0, 45.4473, 0, 0, 96.0006, 0, 0, 3.02784e-14, 0, 0, 4.15411e-15], 
   [96.0006, 0, 0, 431.999, 0, 0, -1.2043e-13, 0, 0, 1.30651e-14, 0, 0], 
   [0, 96.0006, 0, 0, 431.999, 0, 0, -4.57856e-14, 0, 0, -3.10442e-14, 0], 
   [0, 0, 96.0006, 0, 0, 431.999, 0, 0, 1.75129e-14, 0, 0, -2.35758e-15], 
   [-5.66721e-14, 0, 0, -1.2043e-13, 0, 0, 12.0115, 0, 0, 1.61326, 0, 0], 
   [0, -4.75804e-14, 0, 0, -4.57856e-14, 0, 0, 11.9231, 0, 0, 1.51189, 0], 
   [0, 0, 3.02784e-14, 0, 0, 1.75129e-14, 0, 0, 12.085, 0, 0, 1.6981], 
   [-1.39949e-15, 0, 0, 1.30651e-14, 0, 0, 1.61326, 0, 0, 2.35728, 0, 0], 
   [0, -1.16787e-14, 0, 0, -3.10442e-14, 0, 0, 1.51189, 0, 0, 2.22722, 0], 
   [0, 0, 4.15411e-15, 0, 0, -2.35758e-15, 0, 0, 1.6981, 0, 0, 2.46742]] */
  casadi_copy(casadi_c0, 144, w6);
  /* #8: @1 = mac(@3,@6,@1) */
  for (i=0, rr=w1; i<12; ++i) for (j=0; j<1; ++j, ++rr) for (k=0, ss=w3+j, tt=w6+i*12; k<12; ++k) *rr += ss[k*1]**tt++;
  /* #9: @2 = (@2-@4) */
  for (i=0, rr=w2, cs=w4; i<12; ++i) (*rr++) -= (*cs++);
  /* #10: @0 = mac(@1,@2,@0) */
  for (i=0, rr=(&w0); i<1; ++i) for (j=0; j<1; ++j, ++rr) for (k=0, ss=w1+j, tt=w2+i*12; k<12; ++k) *rr += ss[k*1]**tt++;
  /* #11: output[0][0] = @0 */
  if (res[0]) res[0][0] = w0;
  /* #12: @1 = @1' */
  /* #13: @4 = zeros(1x12) */
  casadi_clear(w4, 12);
  /* #14: @2 = @2' */
  /* #15: @7 = @6' */
  for (i=0, rr=w7, cs=w6; i<12; ++i) for (j=0; j<12; ++j) rr[i+j*12] = *cs++;
  /* #16: @4 = mac(@2,@7,@4) */
  for (i=0, rr=w4; i<12; ++i) for (j=0; j<1; ++j, ++rr) for (k=0, ss=w2+j, tt=w7+i*12; k<12; ++k) *rr += ss[k*1]**tt++;
  /* #17: @4 = @4' */
  /* #18: @1 = (@1+@4) */
  for (i=0, rr=w1, cs=w4; i<12; ++i) (*rr++) += (*cs++);
  /* #19: output[1][0] = @1 */
  casadi_copy(w1, 12, res[1]);
  return 0;
}

CASADI_SYMBOL_EXPORT int astrobee_cost_ext_cost_e_fun_jac(const casadi_real** arg, casadi_real** res, casadi_int* iw, casadi_real* w, int mem){
  return casadi_f0(arg, res, iw, w, mem);
}

CASADI_SYMBOL_EXPORT int astrobee_cost_ext_cost_e_fun_jac_alloc_mem(void) {
  return 0;
}

CASADI_SYMBOL_EXPORT int astrobee_cost_ext_cost_e_fun_jac_init_mem(int mem) {
  return 0;
}

CASADI_SYMBOL_EXPORT void astrobee_cost_ext_cost_e_fun_jac_free_mem(int mem) {
}

CASADI_SYMBOL_EXPORT int astrobee_cost_ext_cost_e_fun_jac_checkout(void) {
  return 0;
}

CASADI_SYMBOL_EXPORT void astrobee_cost_ext_cost_e_fun_jac_release(int mem) {
}

CASADI_SYMBOL_EXPORT void astrobee_cost_ext_cost_e_fun_jac_incref(void) {
}

CASADI_SYMBOL_EXPORT void astrobee_cost_ext_cost_e_fun_jac_decref(void) {
}

CASADI_SYMBOL_EXPORT casadi_int astrobee_cost_ext_cost_e_fun_jac_n_in(void) { return 4;}

CASADI_SYMBOL_EXPORT casadi_int astrobee_cost_ext_cost_e_fun_jac_n_out(void) { return 2;}

CASADI_SYMBOL_EXPORT casadi_real astrobee_cost_ext_cost_e_fun_jac_default_in(casadi_int i){
  switch (i) {
    default: return 0;
  }
}

CASADI_SYMBOL_EXPORT const char* astrobee_cost_ext_cost_e_fun_jac_name_in(casadi_int i){
  switch (i) {
    case 0: return "i0";
    case 1: return "i1";
    case 2: return "i2";
    case 3: return "i3";
    default: return 0;
  }
}

CASADI_SYMBOL_EXPORT const char* astrobee_cost_ext_cost_e_fun_jac_name_out(casadi_int i){
  switch (i) {
    case 0: return "o0";
    case 1: return "o1";
    default: return 0;
  }
}

CASADI_SYMBOL_EXPORT const casadi_int* astrobee_cost_ext_cost_e_fun_jac_sparsity_in(casadi_int i) {
  switch (i) {
    case 0: return casadi_s0;
    case 1: return casadi_s1;
    case 2: return casadi_s1;
    case 3: return casadi_s2;
    default: return 0;
  }
}

CASADI_SYMBOL_EXPORT const casadi_int* astrobee_cost_ext_cost_e_fun_jac_sparsity_out(casadi_int i) {
  switch (i) {
    case 0: return casadi_s3;
    case 1: return casadi_s0;
    default: return 0;
  }
}

CASADI_SYMBOL_EXPORT int astrobee_cost_ext_cost_e_fun_jac_work(casadi_int *sz_arg, casadi_int* sz_res, casadi_int *sz_iw, casadi_int *sz_w) {
  if (sz_arg) *sz_arg = 7;
  if (sz_res) *sz_res = 3;
  if (sz_iw) *sz_iw = 0;
  if (sz_w) *sz_w = 350;
  return 0;
}


#ifdef __cplusplus
} /* extern "C" */
#endif