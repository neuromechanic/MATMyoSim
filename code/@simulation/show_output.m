function show_output(obj,varargin)
% Function draws output

p = inputParser;
addOptional(p,'trace_line_width',1);
addOptional(p,'color_map',[1 0 0 ; 0 1 0 ; 0 0 1 ; jet(20)]);
addOptional(p,'t_counter',[]);
parse(p,varargin{:});
p = p.Results;


if (isempty(obj.sim_output.subplots))
    % make a figure
    obj.sim_output.subplots = ...
        initialise_publication_quality_figure( ...
                'figure_handle',1, ...
                'no_of_panels_wide',2, ...
                'no_of_panels_high',4, ...
                'right_margin',1, ...
                'x_to_y_axes_ratio',2, ...
                'axes_padding_top',0.7, ...
                'axes_padding_bottom',0.3, ...
                'axes_padding_left',1, ...
                'axes_padding_right',0.5, ...
                'panel_label_font_size',0);
end

subplot(obj.sim_output.subplots(1));
cla;
plot(obj.sim_output.time_s,obj.sim_output.muscle_length,'k-', ...
        'LineWidth',p.trace_line_width);
xlim([0 max(obj.sim_output.time_s)]);
ylabel('Muscle length');

subplot(obj.sim_output.subplots(3));
cla
plot(obj.sim_output.time_s,obj.sim_output.muscle_force,'k-', ...
        'LineWidth',p.trace_line_width);
xlim([0 max(obj.sim_output.time_s)]);
ylabel('Muscle force');

subplot(obj.sim_output.subplots(5));
cla
hold on;
for j=1:obj.m.no_of_half_sarcomeres
    plot(obj.sim_output.time_s,obj.sim_output.hs_force(:,j),'-', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
    plot(obj.sim_output.time_s,obj.sim_output.cb_force(:,j),':', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
    plot(obj.sim_output.time_s,obj.sim_output.pas_force(:,j),'--', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
end
ylabel('Half-sarcomere forces');
xlim([0 max(obj.sim_output.time_s)]);

subplot(obj.sim_output.subplots(7));
cla
hold on
for j=1:obj.m.no_of_half_sarcomeres
    plot(obj.sim_output.time_s,obj.sim_output.hs_length(:,j),'-', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
end
ylabel('Half-sarcomere lengths');
xlim([0 max(obj.sim_output.time_s)]);
 
subplot(obj.sim_output.subplots(2));
cla;
hold on;
for j=1:obj.m.no_of_half_sarcomeres
    h=[];
    h(1) = plot(obj.sim_output.time_s,obj.sim_output.f_overlap(:,j),':', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
    h(2) = plot(obj.sim_output.time_s,obj.sim_output.f_activated(:,j),'-', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
    h(3) = plot(obj.sim_output.time_s,obj.sim_output.f_bound(:,j),'--', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
end
legendflex(h,{'Overlap','Activated','Bound'}, ...
    'nrow',1, ...
    'anchor',[2 6], ...
    'buffer',[0 10], ...
    'xscale',0.3);
xlim([0 max(obj.sim_output.time_s)]);

subplot(obj.sim_output.subplots(4));
cla
hold on;
for j=1:obj.m.no_of_half_sarcomeres
    plot(obj.sim_output.time_s,-log10(obj.sim_output.Ca(:,j)),'-', ...
        'Color',p.color_map(j,:), ...
        'LineWidth',p.trace_line_width);
end
ylabel('pCa');
xlim([0 max(obj.sim_output.time_s)]);


switch (obj.myosim_model.hs_props.kinetic_scheme)
    case '3state_with_SRX';
        subplot(obj.sim_output.subplots(6));
        cla
        hold on;
        for j=1:obj.m.no_of_half_sarcomeres
            h=[];
            h(1)=plot(obj.sim_output.time_s,obj.sim_output.M1(:,j),':', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            h(2)=plot(obj.sim_output.time_s,obj.sim_output.M2(:,j),'-', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            h(3)=plot(obj.sim_output.time_s,obj.sim_output.M3(:,j),'--', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
        end
        legendflex(h,{'M1','M2','M3'}, ...
            'nrow',1, ...
            'anchor',[2 6], ...
            'buffer',[0 10], ...
            'xscale',0.3);
        xlim([0 max(obj.sim_output.time_s)]);
        
    case '4state_with_SRX';
        subplot(obj.sim_output.subplots(6));
        cla
        hold on;
        for j=1:obj.m.no_of_half_sarcomeres
            h=[];
            h(1)=plot(obj.sim_output.time_s,obj.sim_output.M1(:,j),':', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            h(2)=plot(obj.sim_output.time_s,obj.sim_output.M2(:,j),'-', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            h(3)=plot(obj.sim_output.time_s,obj.sim_output.M3(:,j),'--', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            h(4)=plot(obj.sim_output.time_s,obj.sim_output.M4(:,j),'+', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
        end
        legendflex(h,{'M1','M2','M3','M4'});
        xlim([0 max(obj.sim_output.time_s)]);        
    otherwise
end

subplot(obj.sim_output.subplots(8));
cla
hold on;
if (isempty(p.t_counter))
    t_index = obj.sim_output.no_of_time_points;
else
    t_index = p.t_counter;
end
for j=1:obj.m.no_of_half_sarcomeres
    switch (obj.myosim_model.hs_props.kinetic_scheme)
        case '3state_with_SRX'
            plot(obj.m.hs(1).myofilaments.x, ...
                squeeze(obj.sim_output.cb_pops(t_index,j,:)),'-', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            ylabel('M3 distributions');
            xlim([min(obj.m.hs(1).myofilaments.x) max(obj.m.hs(1).myofilaments.x)]);
            
        case '4state_with_SRX'
            plot(obj.m.hs(1).myofilaments.x, ...
                squeeze(obj.sim_output.cb_pops(t_index,j,1,:)),'-', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            plot(obj.m.hs(1).myofilaments.x, ...
                squeeze(obj.sim_output.cb_pops(t_index,j,2,:)),':', ...
                'Color',p.color_map(j,:), ...
                'LineWidth',p.trace_line_width);
            xlim([min(obj.m.hs(1).myofilaments.x) max(obj.m.hs(1).myofilaments.x)]);  
    end
          
end

drawnow;