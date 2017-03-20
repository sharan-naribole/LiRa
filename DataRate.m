function [rate, mcs_index] = DataRate(P_RX)
%This function computes the data rate and MCS index 
%   INPUTS:
%   1. P_RX: Received Power in absolute
%  OUTPUTS:
%   1. rate = User / Group data rate in Mbps
%   2. mcs_index = Corresponding MCS index

load global_params;
  
valid_PHY_mode = 1;

if(P_RX < P_RX_min)
    mcs_index = 0;
    %'Unreachable Node - RX Power lower than Control Reqd.'
else
    %% RECEIVED POWER
    mcs_index = 0;

    %OBTAINING MCS INDEX
    if(strcmp(phy_mode,'OOK'))
      if(P_RX < -72)
          mcs_index = 0;
      else
          valid_thresh = sense_thresh_OOK(sense_thresh_OOK <=P_RX);
          [value, ii] = min(abs(valid_thresh - P_RX));
          mcs_index = mcsMap_OOK(valid_thresh(ii));
      end
    elseif(strcmp(phy_mode,'CSK'))
        if(P_RX < -63)
          mcs_index = 0;
      else
          valid_thresh = sense_thresh_CSK(sense_thresh_CSK <=P_RX);
          [value, ii] = min(abs(valid_thresh - P_RX));
          mcs_index = mcsMap_CSK(valid_thresh(ii));
          mcs_lower_posn = find(mcsIndex_CSK < mcs_index,1,'last');
        end
    else
        fprintf('\n NOT A VALID PHY MODE: Please try again\n');
        valid_PHY_mode = 0;
    end

    %% OBTAINING DATA RATE
    if(valid_PHY_mode == 1)
        rate = mcsRateMap(mcs_index);
    else
        rate = [];
    end
end
      
end




