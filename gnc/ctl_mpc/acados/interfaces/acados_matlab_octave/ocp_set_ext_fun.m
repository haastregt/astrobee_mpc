%
% Copyright 2019 Gianluca Frison, Dimitris Kouzoupis, Robin Verschueren,
% Andrea Zanelli, Niels van Duijkeren, Jonathan Frey, Tommaso Sartor,
% Branimir Novoselnik, Rien Quirynen, Rezart Qelibari, Dang Doan,
% Jonas Koenemann, Yutao Chen, Tobias Schöls, Jonas Schlagenhauf, Moritz Diehl
%
% This file is part of acados.
%
% The 2-Clause BSD License
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.;
%

function C_ocp_ext_fun = ocp_set_ext_fun(C_ocp, C_ocp_ext_fun, model_struct, opts_struct)

model_name = model_struct.name;
N = opts_struct.param_scheme_N;

% get acados folder
acados_folder = getenv('ACADOS_INSTALL_DIR');
mex_flags = getenv('ACADOS_MEX_FLAGS');
addpath(fullfile(acados_folder, 'external', 'jsonlab'));

% set paths
acados_mex_folder = fullfile(acados_folder, 'interfaces', 'acados_matlab_octave');
acados_include = ['-I' fullfile(acados_folder,'include')];
acados_interfaces_include = ['-I' fullfile(acados_folder, 'interfaces')];
external_include = ['-I' fullfile(acados_folder, 'external')];
blasfeo_include = ['-I' fullfile(acados_folder, 'include' , 'blasfeo', 'include')];
hpipm_include = ['-I' fullfile(acados_folder, 'include' , 'hpipm', 'include')];
acados_lib_path = ['-L' fullfile(acados_folder, 'lib')];
acados_matlab_octave_lib_path = ['-L' fullfile(acados_folder, 'interfaces', 'acados_matlab_octave')];
model_lib_path = ['-L', opts_struct.output_dir];

%% select files to compile
ocp_set_ext_fun_casadi_mex = fullfile(acados_mex_folder, ['ocp_set_ext_fun_casadi.c']);
ocp_set_dyn_ext_fun_mex = fullfile(acados_mex_folder, ['ocp_set_ext_fun_', model_struct.dyn_ext_fun_type, '.c']);
ocp_set_cost_ext_fun_mex = fullfile(acados_mex_folder, ['ocp_set_ext_fun_', model_struct.cost_ext_fun_type, '.c']);
ocp_set_cost_ext_fun_mex_e = fullfile(acados_mex_folder, ['ocp_set_ext_fun_', model_struct.cost_ext_fun_type_e, '.c']);
% TODO: complete separate stage 0 handling
%ocp_set_ext_fun_mex_0 = fullfile(acados_mex_folder, ['ocp_set_ext_fun_', model_struct.cost_ext_fun_type_0, '.c']);
mex_files = {};
setter = {};
set_fields = {};
mex_fields = {};
fun_names = {};
mex_names = {};
phase = {};
phase_start = {};
phase_end = {};

% dynamics
if (strcmp(model_struct.dyn_type, 'explicit'))
    mex_files = {mex_files{:} ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        };
    setter = {setter{:} ...
        'ocp_nlp_dynamics_model_set' ...
        'ocp_nlp_dynamics_model_set' ...
        'ocp_nlp_dynamics_model_set' ...
        'ocp_nlp_dynamics_model_set' ...
        };
    set_fields = {set_fields{:} ...
        'expl_ode_fun' ...
        'expl_vde_forw' ...
        'expl_vde_adj' ...
        'expl_ode_hess' ...
        };
    mex_fields = {mex_fields{:} ...
        'dyn_expl_ode_fun' ...
        'dyn_expl_vde_forw' ...
        'dyn_expl_vde_adj' ...
        'dyn_expl_ode_hess' ...
        };
    fun_names = {fun_names{:} ...
        [model_name, '_dyn_expl_ode_fun'] ...
        [model_name, '_dyn_expl_vde_forw'] ...
        [model_name, '_dyn_expl_vde_adj'] ...
        [model_name, '_dyn_expl_ode_hess'] ...
        };
    mex_names = {mex_names{:} ...
        [model_name, '_ocp_set_ext_fun_dyn_0_expl_ode_fun'] ...
        [model_name, '_ocp_set_ext_fun_dyn_0_expl_vde_forw'] ...
        [model_name, '_ocp_set_ext_fun_dyn_0_expl_vde_adj'] ...
        [model_name, '_ocp_set_ext_fun_dyn_0_expl_ode_hess'] ...
        };
    phase = {phase{:}, 0, 0, 0, 0};
    phase_start = {phase_start{:}, 0, 0, 0, 0};
    phase_end = {phase_end{:}, N-1, N-1, N-1, N-1};

elseif (strcmp(model_struct.dyn_type, 'implicit'))

    if (strcmp(opts_struct.sim_method, 'irk'))
        mex_files = {mex_files{:} ...
            ocp_set_ext_fun_casadi_mex ...
            ocp_set_ext_fun_casadi_mex ...
            ocp_set_ext_fun_casadi_mex ...
            };
        setter = {setter{:} ...
            'ocp_nlp_dynamics_model_set' ...
            'ocp_nlp_dynamics_model_set' ...
            'ocp_nlp_dynamics_model_set' ...
            };
        set_fields = {set_fields{:} ...
            'impl_dae_fun' ...
            'impl_dae_fun_jac_x_xdot_z' ...
            'impl_dae_jac_x_xdot_u_z' ...
            };
        mex_fields = {mex_fields{:} ...
            'dyn_impl_dae_fun' ...
            'dyn_impl_dae_fun_jac_x_xdot_z' ...
            'dyn_impl_dae_jac_x_xdot_u_z' ...
            };
        fun_names = {fun_names{:} ...
            [model_name, '_dyn_impl_dae_fun'] ...
            [model_name, '_dyn_impl_dae_fun_jac_x_xdot_z'] ...
            [model_name, '_dyn_impl_dae_jac_x_xdot_u_z'] ...
            };
        mex_names = {mex_names{:} ...
            [model_name, '_ocp_set_ext_fun_dyn_0_impl_dae_fun'] ...
            [model_name, '_ocp_set_ext_fun_dyn_0_impl_dae_fun_jac_x_xdot_z'] ...
            [model_name, '_ocp_set_ext_fun_dyn_0_impl_dae_jac_x_xdot_u_z'] ...
            };
        phase = {phase{:}, 0, 0, 0};
        phase_start = {phase_start{:}, 0, 0, 0};
        phase_end = {phase_end{:}, N-1, N-1, N-1};

        if strcmp(opts_struct.nlp_solver_exact_hessian, 'true')
            mex_files = {mex_files{:} ...
                ocp_set_ext_fun_casadi_mex ...
                };            
            setter = {setter{:} ...
            'ocp_nlp_dynamics_model_set' ...
            };
            set_fields = {set_fields{:} ...
                'impl_dae_hess' ...
                };
            mex_fields = {mex_fields{:} ...
                'dyn_impl_dae_hess' ...
                };
            fun_names = {fun_names{:} ...
                [model_name, '_dyn_impl_dae_hess'] ...
                };
            mex_names = {mex_names{:} ...
                [model_name, '_ocp_set_ext_fun_dyn_0_impl_dae_hess'] ...
                };
            phase = {phase{:}, 0};
            phase_start = {phase_start{:}, 0};
            phase_end = {phase_end{:}, N-1};
        end


    elseif (strcmp(opts_struct.sim_method, 'irk_gnsf'))
        if ~model_struct.dyn_gnsf_purely_linear
            if model_struct.dyn_gnsf_nontrivial_f_LO
                mex_files = {mex_files{:} ...
                    ocp_set_ext_fun_casadi_mex ...
                    };                            
                setter = {setter{:} ...
                    'ocp_nlp_dynamics_model_set'};
                set_fields = {set_fields{:} ...
                    'gnsf_f_lo_fun_jac_x1k1uz' };
                mex_fields = {mex_fields{:} ...
                    'dyn_gnsf_f_lo_fun_jac_x1k1uz' };
                fun_names = {fun_names{:} ...
                    [model_name, '_dyn_gnsf_f_lo_fun_jac_x1k1uz'] };
                mex_names = {mex_names{:} ...
                    [model_name, '_ocp_set_ext_fun_dyn_0_gnsf_f_lo_fun_jac_x1k1uz'] };
                phase = {phase{:}, 0};
                phase_start = {phase_start{:}, 0};
                phase_end = {phase_end{:}, N-1 };
            end
            mex_files = {mex_files{:} ...
                ocp_set_ext_fun_casadi_mex ...
                ocp_set_ext_fun_casadi_mex ...
                ocp_set_ext_fun_casadi_mex ...
                };            
            setter = {setter{:} ...
                'ocp_nlp_dynamics_model_set' ...
                'ocp_nlp_dynamics_model_set' ...
                'ocp_nlp_dynamics_model_set' ...
                };
            set_fields = {set_fields{:} ...
                'gnsf_phi_fun' ...
                'gnsf_phi_fun_jac_y' ...
                'gnsf_phi_jac_y_uhat' ...
                };
            mex_fields = {mex_fields{:} ...
                'dyn_gnsf_phi_fun' ...
                'dyn_gnsf_phi_fun_jac_y' ...
                'dyn_gnsf_phi_jac_y_uhat' ...
                };
            fun_names = {fun_names{:} ...
                [model_name, '_dyn_gnsf_phi_fun'] ...
                [model_name, '_dyn_gnsf_phi_fun_jac_y'] ...
                [model_name, '_dyn_gnsf_phi_jac_y_uhat'] ...
                };
            mex_names = {mex_names{:} ...
                [model_name, '_ocp_set_ext_fun_dyn_0_gnsf_phi_fun'] ...
                [model_name, '_ocp_set_ext_fun_dyn_0_gnsf_phi_fun_jac_y'] ...
                [model_name, '_ocp_set_ext_fun_dyn_0_gnsf_phi_jac_y_uhat'] ...
                };
            phase = {phase{:}, 0, 0, 0};
            phase_start = {phase_start{:}, 0, 0, 0};
            phase_end = {phase_end{:}, N-1, N-1, N-1};
        end
        mex_files = {mex_files{:} ...
            ocp_set_ext_fun_casadi_mex ...
            };         
        setter = {setter{:} ...
            'ocp_nlp_dynamics_model_set' ...
            };
        set_fields = {set_fields{:} ...
            'gnsf_get_matrices_fun' ...
            };
        mex_fields = {mex_fields{:} ...
            'dyn_gnsf_get_matrices_fun' ...
            };
        fun_names = {fun_names{:} ...
            [model_name, '_dyn_gnsf_get_matrices_fun'] ...
            };
        mex_names = {mex_names{:} ...
            [model_name, '_ocp_set_ext_fun_dyn_0_gnsf_get_matrices_fun'] ...
            };
        phase = {phase{:}, 0};
        phase_start = {phase_start{:}, 0};
        phase_end = {phase_end{:}, N-1};

    else
        fprintf('\nocp_set_ext_fun: sim_method not supported: %s\n', opts_struct.sim_method);
    end

elseif (strcmp(model_struct.dyn_type, 'discrete'))
    if (strcmp(model_struct.dyn_ext_fun_type, 'casadi'))
        mex_files = {mex_files{:} ...
            ocp_set_ext_fun_casadi_mex ...
            ocp_set_ext_fun_casadi_mex ...
            ocp_set_ext_fun_casadi_mex ...
            }; 
        setter = {setter{:} ...
            'ocp_nlp_dynamics_model_set' ...
            'ocp_nlp_dynamics_model_set' ...
            'ocp_nlp_dynamics_model_set' ...
            };
        set_fields = {set_fields{:} ...
            'disc_dyn_fun' ...
            'disc_dyn_fun_jac' ...
            'disc_dyn_fun_jac_hess' ...
            };
        mex_fields = {mex_fields{:} ...
            'dyn_disc_phi_fun' ...
            'dyn_disc_phi_fun_jac' ...
            'dyn_disc_phi_fun_jac_hess' ...
            };
        fun_names = {fun_names{:} ...
            [model_name, '_dyn_disc_phi_fun'] ...
            [model_name, '_dyn_disc_phi_fun_jac'] ...
            [model_name, '_dyn_disc_phi_fun_jac_hess'] ...
            };
        mex_names = {mex_names{:} ...
            [model_name, '_ocp_set_ext_fun_dyn_0_disc_phi_fun'] ...
            [model_name, '_ocp_set_ext_fun_dyn_0_disc_phi_fun_jac'] ...
            [model_name, '_ocp_set_ext_fun_dyn_0_disc_phi_fun_jac_hess'] ...
            };
        phase = {phase{:}, 0, 0, 0};
        phase_start = {phase_start{:}, 0, 0, 0};
        phase_end = {phase_end{:}, N-1, N-1, N-1};
    elseif (strcmp(model_struct.dyn_ext_fun_type, 'generic'))
        if strcmp(opts_struct.nlp_solver_exact_hessian, 'true')
            mex_files = {mex_files{:} ...
                ocp_set_dyn_ext_fun_mex ...
                };
            setter = {setter{:} ...
                'ocp_nlp_dynamics_model_set' ...
                };
            set_fields = {set_fields{:} ...
                'disc_dyn_fun_jac_hess' ...
                };
            mex_fields = {mex_fields{:} ...
                'dyn_disc_phi_fun_jac_hess' ...
                };
            fun_names = {fun_names{:} ...
                model_struct.dyn_disc_fun_jac_hess ...
                };
            mex_names = {mex_names{:} ...
                [model_name, '_ocp_set_ext_fun_dyn_0_disc_phi_fun_jac_hess'] ...
                };
            phase = {phase{:}, 0};
            phase_start = {phase_start{:}, 0};
            phase_end = {phase_end{:}, N-1};
        end
        mex_files = {mex_files{:} ...
            ocp_set_dyn_ext_fun_mex ...
            };
        setter = {setter{:} ...
            'ocp_nlp_dynamics_model_set' ...
            };
        set_fields = {set_fields{:} ...
            'disc_dyn_fun_jac' ...
            };
        mex_fields = {mex_fields{:} ...
            'dyn_disc_phi_fun_jac' ...
            };
        fun_names = {fun_names{:} ...
            model_struct.dyn_disc_fun_jac ...
            };
        mex_names = {mex_names{:} ...
            [model_name, '_ocp_set_ext_fun_dyn_0_disc_phi_fun_jac'] ...
            };
        phase = {phase{:}, 0};
        phase_start = {phase_start{:}, 0};
        phase_end = {phase_end{:}, N-1};

        mex_files = {mex_files{:} ...
            ocp_set_dyn_ext_fun_mex ...
            };
        setter = {setter{:} ...
            'ocp_nlp_dynamics_model_set' ...
            };
        set_fields = {set_fields{:} ...
            'disc_dyn_fun' ...
            };
        mex_fields = {mex_fields{:} ...
            'dyn_disc_phi_fun' ...
            };
        fun_names = {fun_names{:} ...
            model_struct.dyn_disc_fun ...
            };
        mex_names = {mex_names{:} ...
            [model_name, '_ocp_set_ext_fun_dyn_0_disc_phi_fun'] ...
            };
        phase = {phase{:}, 0};
        phase_start = {phase_start{:}, 0};
        phase_end = {phase_end{:}, N-1};
    end
else
    fprintf('\nocp_compile_interface_mode_dep: dyn_type not supported: %s\n', model_struct.dyn_type);
end

% nonlinear constraints
if (strcmp(model_struct.constr_type, 'bgh') && (isfield(model_struct, 'dim_nh') && model_struct.dim_nh>0))
    mex_files = {mex_files{:} ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        };
    setter = {setter{:} ...
        'ocp_nlp_constraints_model_set' ...
        'ocp_nlp_constraints_model_set' ...
        'ocp_nlp_constraints_model_set' ...
        };
    set_fields = {set_fields{:} ...
        'nl_constr_h_fun' ...
        'nl_constr_h_fun_jac' ...
        'nl_constr_h_fun_jac_hess' ...
        };
    mex_fields = {mex_fields{:} ...
        'constr_h_fun' ...
        'constr_h_fun_jac_uxt_zt' ...
        'constr_h_fun_jac_uxt_zt_hess' ...
        };
    fun_names = {fun_names{:} ...
        [model_name, '_constr_h_fun'] ...
        [model_name, '_constr_h_fun_jac_uxt_zt'] ...
        [model_name, '_constr_h_fun_jac_uxt_zt_hess'] ...
        };
    mex_names = {mex_names{:} ...
        [model_name, '_ocp_set_ext_fun_constr_0_h_fun'] ...
        [model_name, '_ocp_set_ext_fun_constr_0_h_fun_jac_uxt_zt'] ...
        [model_name, '_ocp_set_ext_fun_constr_0_h_fun_jac_uxt_zt_hess'] ...
        };
    phase = {phase{:}, 0, 0, 0};
    phase_start = {phase_start{:}, 0, 0, 0};
    phase_end = {phase_end{:}, N-1, N-1, N-1};

end
if (strcmp(model_struct.constr_type, 'bgh') && (isfield(model_struct, 'dim_nh_e') && model_struct.dim_nh_e>0))
    mex_files = {mex_files{:} ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        };
    setter = {setter{:} ...
        'ocp_nlp_constraints_model_set' ...
        'ocp_nlp_constraints_model_set' ...
        'ocp_nlp_constraints_model_set' ...
        };
    set_fields = {set_fields{:} ...
        'nl_constr_h_fun' ...
        'nl_constr_h_fun_jac' ...
        'nl_constr_h_fun_jac_hess' ...
        };
    mex_fields = {mex_fields{:} ...
        'constr_h_fun' ...
        'constr_h_fun_jac_uxt_zt' ...
        'constr_h_fun_jac_uxt_zt_hess' ...
        };
    fun_names = {fun_names{:} ...
        [model_name, '_constr_h_e_fun'] ...
        [model_name, '_constr_h_e_fun_jac_uxt_zt'] ...
        [model_name, '_constr_h_e_fun_jac_uxt_zt_hess'] ...
        };
    mex_names = {mex_names{:} ...
        [model_name, '_ocp_set_ext_fun_constr_1_h_fun'] ...
        [model_name, '_ocp_set_ext_fun_constr_1_h_fun_jac_uxt_zt'] ...
        [model_name, '_ocp_set_ext_fun_constr_1_h_fun_jac_uxt_zt_hess'] ...
        };
    phase = {phase{:}, 1, 1, 1};
    phase_start = {phase_start{:}, N, N, N};
    phase_end = {phase_end{:}, N, N, N};

end
% nonlinear least squares
if (strcmp(model_struct.cost_type, 'nonlinear_ls'))
    mex_files = {mex_files{:} ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        }; 
    setter = {setter{:} ...
        'ocp_nlp_cost_model_set' ...
        'ocp_nlp_cost_model_set' ...
        'ocp_nlp_cost_model_set' ...
        };
    set_fields = {set_fields{:} ...
        'nls_res' ...
        'nls_res_jac' ...
        'nls_hess' ...
        };
    mex_fields = {mex_fields{:} ...
        'cost_y_fun' ...
        'cost_y_fun_jac_ut_xt' ...
        'cost_y_hess' ...
        };
    fun_names = {fun_names{:} ...
        [model_name, '_cost_y_fun'] ...
        [model_name, '_cost_y_fun_jac_ut_xt'] ...
        [model_name, '_cost_y_hess'] ...
        };
    mex_names = {mex_names{:} ...
        [model_name, '_ocp_set_ext_fun_cost_0_y_fun'] ...
        [model_name, '_ocp_set_ext_fun_cost_0_y_fun_jac_ut_xt'] ...
        [model_name, '_ocp_set_ext_fun_cost_0_y_hess'] ...
        };
    phase = {phase{:}, 0, 0, 0};
    phase_start = {phase_start{:}, 0, 0, 0};
    phase_end = {phase_end{:}, N-1, N-1, N-1};

end
if (strcmp(model_struct.cost_type_e, 'nonlinear_ls'))
    mex_files = {mex_files{:} ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        ocp_set_ext_fun_casadi_mex ...
        }; 
    setter = {setter{:} ...
        'ocp_nlp_cost_model_set' ...
        'ocp_nlp_cost_model_set' ...
        'ocp_nlp_cost_model_set' ...
        };
    set_fields = {set_fields{:} ...
        'nls_res' ...
        'nls_res_jac' ...
        'nls_hess' ...
        };
    mex_fields = {mex_fields{:} ...
        'cost_y_fun' ...
        'cost_y_fun_jac_ut_xt' ...
        'cost_y_hess' ...
        };
    fun_names = {fun_names{:} ...
        [model_name, '_cost_y_e_fun'] ...
        [model_name, '_cost_y_e_fun_jac_ut_xt'] ...
        [model_name, '_cost_y_e_hess'] ...
        };
    mex_names = {mex_names{:} ...
        [model_name, '_ocp_set_ext_fun_cost_1_y_fun'] ...
        [model_name, '_ocp_set_ext_fun_cost_1_y_fun_jac_ut_xt'] ...
        [model_name, '_ocp_set_ext_fun_cost_1_y_hess'] ...
        };
    phase = {phase{:}, 1, 1, 1};
    phase_start = {phase_start{:}, N, N, N};
    phase_end = {phase_end{:}, N, N, N};

end
% external cost
if (strcmp(model_struct.cost_type, 'ext_cost'))
    
    if (strcmp(model_struct.cost_ext_fun_type, 'casadi'))
        mex_files = {mex_files{:} ...
            ocp_set_cost_ext_fun_mex ...
            ocp_set_cost_ext_fun_mex ...
            };         
        setter = {setter{:} ...
            'ocp_nlp_cost_model_set' ...
            'ocp_nlp_cost_model_set' ...
        };
        set_fields = {set_fields{:} ...
            'ext_cost_fun_jac_hess' ...
            'ext_cost_fun' ...
        };
        mex_fields = {mex_fields{:} ...
            'cost_ext_cost_fun_jac_hess' ...
            'cost_ext_cost_fun' ...
        };
        mex_names = {mex_names{:} ...       
            [model_name, '_ocp_set_ext_fun_cost_0_ext_cost_fun_jac_hess'] ...
            [model_name, '_ocp_set_ext_fun_cost_0_ext_cost_fun'] ...
        };   
        fun_names = {fun_names{:} ...
            [model_name, '_cost_ext_cost_fun_jac_hess'] ...
            [model_name, '_cost_ext_cost_fun'] ...
        };        
        phase = {phase{:}, 0, 0};
        phase_start = {phase_start{:}, 0, 0};
        phase_end = {phase_end{:}, N-1, N-1};
    elseif (strcmp(model_struct.cost_ext_fun_type, 'generic'))
        if (isfield(model_struct, 'cost_source_ext_cost') && isfield(model_struct, 'cost_function_ext_cost'))
            mex_files = {mex_files{:} ...
                ocp_set_cost_ext_fun_mex ...
                };             
            setter = {setter{:} ...
                'ocp_nlp_cost_model_set' ...       
            };
            set_fields = {set_fields{:} ...
                'ext_cost_fun_jac_hess' ...
            };
            mex_fields = {mex_fields{:} ...
                'cost_ext_cost_fun_jac_hess' ...
            };
            mex_names = {mex_names{:} ...       
                [model_name, '_ocp_set_ext_fun_cost_0_ext_cost_fun_jac_hess'] ...
            };   
            fun_names = {fun_names{:} ...
                model_struct.cost_function_ext_cost ...
            };
            phase = {phase{:}, 0};
            phase_start = {phase_start{:}, 0};
            phase_end = {phase_end{:}, N-1};
        else
            error('Missing external function and source file for cost');
        end
    end

end
if (strcmp(model_struct.cost_type_e, 'ext_cost'))

    if (strcmp(model_struct.cost_ext_fun_type_e, 'casadi'))
        mex_files = {mex_files{:} ...
            ocp_set_cost_ext_fun_mex_e ...
            ocp_set_cost_ext_fun_mex_e ...
            };           
        setter = {setter{:} ...
            'ocp_nlp_cost_model_set' ...
            'ocp_nlp_cost_model_set' ...
        };
        set_fields = {set_fields{:} ...
            'ext_cost_fun_jac_hess' ...
            'ext_cost_fun' ...
        };
        mex_fields = {mex_fields{:} ...
            'cost_ext_cost_fun_jac_hess' ...
            'cost_ext_cost_fun' ...
        };
        mex_names = {mex_names{:} ...
            [model_name, '_ocp_set_ext_fun_cost_1_ext_cost_fun_jac_hess'] ...
            [model_name, '_ocp_set_ext_fun_cost_1_ext_cost_fun'] ...
        };
        fun_names = {fun_names{:} ...
            [model_name, '_cost_ext_cost_e_fun_jac_hess'] ...
            [model_name, '_cost_ext_cost_e_fun'] ...
        };
        phase = {phase{:}, 1, 1};
        phase_start = {phase_start{:}, N, N};
        phase_end = {phase_end{:}, N, N};     
    elseif (strcmp(model_struct.cost_ext_fun_type_e, 'generic'))
        if (isfield(model_struct, 'cost_source_ext_cost_e') && isfield(model_struct, 'cost_function_ext_cost_e'))
            mex_files = {mex_files{:} ...
                ocp_set_cost_ext_fun_mex_e ...
                };               
            setter = {setter{:} ...
                'ocp_nlp_cost_model_set' ...
            };
            set_fields = {set_fields{:} ...
                'ext_cost_fun_jac_hess' ...
            };
            mex_fields = {mex_fields{:} ...
                'cost_ext_cost_fun_jac_hess' ...
            };
            mex_names = {mex_names{:} ...
                [model_name, '_ocp_set_ext_fun_cost_1_ext_cost_fun_jac_hess'] ...
            };
            fun_names = {fun_names{:} ...
                model_struct.cost_function_ext_cost_e ...
            };       
            phase = {phase{:}, 1};
            phase_start = {phase_start{:}, N};
            phase_end = {phase_end{:}, N};
        else
            error('Missing external function and source file for terminal cost');
        end
    end    
end

% compile mex files
%mex_files
%setter
%set_fields
%mex_fields
%fun_names
%mex_names
%phase
%phase_start
%phase_end
if (strcmp(opts_struct.compile_interface, 'true') || strcmp(opts_struct.codgen_model, 'true'))

    % load linking information
    libs = loadjson(fileread(fullfile(acados_folder, 'lib', 'link_libs.json')));

    if is_octave()
        if ~exist(fullfile(opts_struct.output_dir, 'cflags_octave.txt'), 'file')
            diary(fullfile(opts_struct.output_dir, 'cflags_octave.txt'))
            diary on
            mkoctfile -p CFLAGS
            diary off
            input_file = fopen(fullfile(opts_struct.output_dir, 'cflags_octave.txt'), 'r');
            cflags_tmp = fscanf(input_file, '%[^\n]s');
            fclose(input_file);
            cflags_tmp = [cflags_tmp, ' -std=c99'];
            input_file = fopen(fullfile(opts_struct.output_dir, 'cflags_octave.txt'), 'w');
            fprintf(input_file, '%s', cflags_tmp);
            fclose(input_file);
        end
    end

    %% get pointers for external functions in model
    for ii=1:length(mex_names)

        disp(['compiling ', mex_names{ii}])
        if is_octave()
    %        mkoctfile -p CFLAGS
            input_file = fopen(fullfile(opts_struct.output_dir, 'cflags_octave.txt'), 'r');
            cflags_tmp = fscanf(input_file, '%[^\n]s');
            fclose(input_file);
            cflags_tmp = [cflags_tmp, ' -DSETTER=', setter{ii}];
            cflags_tmp = [cflags_tmp, ' -DSET_FIELD=', set_fields{ii}];
            cflags_tmp = [cflags_tmp, ' -DMEX_FIELD=', mex_fields{ii}];
            cflags_tmp = [cflags_tmp, ' -DFUN_NAME=', fun_names{ii}];
            cflags_tmp = [cflags_tmp, ' -DPHASE=', num2str(phase{ii})];
            cflags_tmp = [cflags_tmp, ' -DN0=', num2str(phase_start{ii})];
            cflags_tmp = [cflags_tmp, ' -DN1=', num2str(phase_end{ii})];
            setenv('CFLAGS', cflags_tmp);
            if ~ismac() && ~isempty(libs.openmp)
                setenv('LDFLAGS', libs.openmp);
            end
            fn = fieldnames(libs);
            linker_flags = {'-lacados', '-lhpipm', '-lblasfeo'};
            for k = 1:numel(fn)
                if ~isempty(libs.(fn{k}))
                    linker_flags{end+1} = libs.(fn{k});
                end
            end
            mex(acados_include, acados_interfaces_include, external_include, blasfeo_include,...
                hpipm_include, acados_lib_path, acados_matlab_octave_lib_path, model_lib_path, ...
                linker_flags{:}, ['-l', model_name], mex_files{ii});
        else
            FLAGS = 'CFLAGS=$CFLAGS -std=c99';
            LDFLAGS = 'LDFLAGS=$LDFLAGS';
            COMPFLAGS = 'COMPFLAGS=$COMPFLAGS';
            if ~ismac() && ~isempty(libs.openmp)
                LDFLAGS = [LDFLAGS, ' ', libs.openmp];
                COMPFLAGS = [COMPFLAGS, ' ', libs.openmp]; % seems unnecessary
            end
            % gcc uses FLAGS, LDFLAGS
            % MSVC uses COMPFLAGS
            mex(mex_flags, FLAGS, LDFLAGS, COMPFLAGS, ['-DSETTER=', setter{ii}],...
                ['-DSET_FIELD=', set_fields{ii}], ['-DMEX_FIELD=', mex_fields{ii}],...
                ['-DFUN_NAME=', fun_names{ii}], ['-DPHASE=', num2str(phase{ii})],...
                ['-DN0=', num2str(phase_start{ii})], ['-DN1=', num2str(phase_end{ii})],...
                acados_include, acados_interfaces_include, external_include, blasfeo_include,...
                hpipm_include, acados_lib_path, acados_matlab_octave_lib_path, model_lib_path,...
                '-lacados', '-lhpipm', '-lblasfeo', libs.osqp, libs.qpoases, libs.hpmpc,...
                 libs.qpdunes, libs.ooqp, ['-l', model_name], mex_files{ii});
            disable_last_warning();
        end
        
%        clear(mex_names{ii})
        [folder, file] = fileparts(mex_files{ii});
        movefile([file, '.', mexext], fullfile(opts_struct.output_dir, [mex_names{ii}, '.', mexext]));
    end
    
    if is_octave()
        octave_version = OCTAVE_VERSION();
        if octave_version < 5
            movefile('*.o', opts_struct.output_dir);
        end
    end

end
%C_ocp_ext_fun

% codegen the file to call mex files
%fileID = fopen('build/ocp_set_ext_fun_tmp.m', 'w');
%fprintf(fileID, 'function C_ocp_ext_fun = ocp_set_ext_fun_tmp(C_ocp, C_ocp_ext_fun, model_struct, opts_struct)\n');
for ii=1:length(mex_names)
%     disp(['evaluating: ' mex_names{ii}, '(C_ocp, C_ocp_ext_fun, model_struct, opts_struct)'])
    C_ocp_ext_fun = eval([mex_names{ii}, '(C_ocp, C_ocp_ext_fun, model_struct, opts_struct)']);
%    disp(['eval ', mex_names{ii}, ' done']);
%    fprintf(fileID, [mex_names{ii}, '(C_ocp, C_ocp_ext_fun, model_struct, opts_struct);\n']);
end
%fclose(fileID);


end