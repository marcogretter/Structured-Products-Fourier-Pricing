function [dates, rates] = readExcelData(filename)
% Reads data from excel
%  It reads bid/ask prices and relevant dates
%  All input rates are in % units
%
% INPUTS:
%  filename: excel file name where data are stored
% 
% OUTPUTS:
%  dates: struct with settlementDate, deposDates, futuresDates, swapDates
%  rates: struct with deposRates, futuresRates, swapRates

    %% Dates from Excel
    % Settlement date
    settlement_excel = readmatrix(filename, 'Sheet', 1, 'Range', 'E8');
    dates.settlement = x2mdate(settlement_excel(1, 1));
    
    % Dates relative to depos
    depos_excel = readmatrix(filename, 'Sheet', 1, 'Range', 'D11:D18');
    dates.depos = x2mdate(depos_excel);
    
    % Dates relative to futures: calc start & end
    futures_excel = readmatrix(filename, 'Sheet', 1, 'Range', 'Q12:R20');
    dates.futures = x2mdate(futures_excel);
    
    % Date relative to swaps: expiry dates
    swaps_excel = readmatrix(filename, 'Sheet', 1, 'Range', 'D39:D88');
    dates.swaps = x2mdate(swaps_excel);

    %% Rates from Excel (Bids & Asks)
    % Depos
    tassi_depositi = readmatrix(filename, 'Sheet', 1, 'Range', 'E11:F18');
    rates.depos = tassi_depositi / 100;
    
    % Futures
    tassi_futures = readmatrix(filename, 'Sheet', 1, 'Range', 'E28:F36');
    % Rates from futures (convertiamo i prezzi in tassi direttamente qui)
    tassi_futures = 100 - tassi_futures;
    rates.futures = tassi_futures / 100;
    
    % Swaps
    tassi_swaps = readmatrix(filename, 'Sheet', 1, 'Range', 'E39:F88');
    rates.swaps = tassi_swaps / 100;

end % readExcelData