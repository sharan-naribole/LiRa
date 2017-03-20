clear all;
%close all;
clc;

%distances = [50,66,89,109,132,155];
conv = unitsratio('cm','inch');
distances_inch = [35,41,46,51,56,62];
distances_cm = conv*distances_inch;
ang = 0:5:360;


legend_diode = {'Diode 1','Diode 2','Diode 3','Diode 4'};

for iter = max(size(distances_inch))-1
    load(['Lira_diode_array_measures/DiodeArrayMeasurements/' num2str(distances_inch(iter)) 'inch_2.mat']);
    
    diode_val_mean(:,1,iter) = mean(arrayData.diode1,2);
    diode_val_mean(:,2,iter) = mean(arrayData.diode2,2);
    diode_val_mean(:,3,iter) = mean(arrayData.diode3,2);
    diode_val_mean(:,4,iter) = mean(arrayData.diode4,2);
    
    for diode_id = 1:1:4
        for ang_iter = 1:1:73
            diode_val_std(ang_iter,1,iter) = std(arrayData.diode1(ang_iter,:));
            diode_val_std(ang_iter,2,iter) = std(arrayData.diode2(ang_iter,:));
            diode_val_std(ang_iter,3,iter) = std(arrayData.diode3(ang_iter,:));
            diode_val_std(ang_iter,4,iter) = std(arrayData.diode4(ang_iter,:));
        end
    end
    
    figure
    colormap inferno;
    for diode_id = 1:1:4
         h = errorbar(ang,squeeze(diode_val_mean(:,diode_id,iter)),squeeze(diode_val_std(:,diode_id,iter)));
         set(h,'linewidth',2);
        hold all;
    end
    grid on;
    axis([0 360 0 3.5])
    title(['Distance = ' num2str(distances_cm(iter)) ' cm']);
    xlabel('ORIENTATION (degree)');
    ylabel('Received Signal Strength (V)');   
    legend(legend_diode);
    set(gca,'FontSize',24,'fontWeight','bold');
    set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
end
    

