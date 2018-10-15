%% Fixed the problem!

%% date_prblm: 729202
date_ = ismember(VarIX_1st.date, VarIX_2nd.date);
date_ = VarIX_1st.date(~date_);

%% empty
VarIX_2nd_tmp = VarIX_2nd(VarIX_2nd.date==date_, :);

%% ~empty
Call_ = CallData_2nd(CallData_2nd.date==date_, :);
Put_ = PutData_2nd(PutData_2nd.date==date_, :);

%%

[T_2nd_] = VIXrawVolCurve(Put_, Call_);

VarIX_2nd_ = VIXConstruction(T_2nd_);
VarIX_2nd = [VarIX_2nd; VarIX_2nd_];
