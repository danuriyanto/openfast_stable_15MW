function [bladepitch,gentorque,rotspeed] = controller_trajectory(windspeed)
bladepitch_pred = readmatrix("../iea15mw-controller_regulation_trajectory/blade_pitch_deg.csv");
gentorque_pred = readmatrix("../iea15mw-controller_regulation_trajectory/gen_torque_mnm.csv");
rotspeed_pred = readmatrix("../iea15mw-controller_regulation_trajectory/rotor_speed_rpm.csv");

bladepitch = interp1(bladepitch_pred(:,1),bladepitch_pred(:,2),windspeed,"linear");
gentorque  = interp1(gentorque_pred(:,1),gentorque_pred(:,2),windspeed,"linear");
rotspeed   = interp1(rotspeed_pred(:,1),rotspeed_pred(:,2),windspeed,"linear");
end