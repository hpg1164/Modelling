classdef app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure              matlab.ui.Figure
        IntroLabel            matlab.ui.control.Label
        HeadEditFieldLabel    matlab.ui.control.Label
        HeadEditField         matlab.ui.control.NumericEditField
        DischargeEditFieldLabel  matlab.ui.control.Label
        DischargeEditField    matlab.ui.control.NumericEditField
        RotationalSpeedEditFieldLabel  matlab.ui.control.Label
        RotationalSpeedEditField  matlab.ui.control.NumericEditField
        StreamlinesEditFieldLabel  matlab.ui.control.Label
        StreamlinesEditField  matlab.ui.control.NumericEditField
        CalculateButton       matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            % Get input values
            H = app.HeadEditField.Value;
            Q = app.DischargeEditField.Value;
            nr = app.RotationalSpeedEditField.Value;
            N = app.StreamlinesEditField.Value;

            % Call the main calculation script with input values
            mainScript(head(H), discharge(Q), rotationalSpeed(nr), streamlines(N));
        end
    end

    % Rest of the code remains unchanged...
    % ...
end