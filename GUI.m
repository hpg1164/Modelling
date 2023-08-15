classdef FrancisTurbineApp < matlab.apps.AppBase

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
            head = app.HeadEditField.Value;
            discharge = app.DischargeEditField.Value;
            rotationalSpeed = app.RotationalSpeedEditField.Value;
            streamlines = app.StreamlinesEditField.Value;

            % Call the main calculation script with input values
            mainScript(head, discharge, rotationalSpeed, streamlines);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Francis Turbine Modeling';

            % Create IntroLabel
            app.IntroLabel = uilabel(app.UIFigure);
            app.IntroLabel.FontSize = 20;
            app.IntroLabel.Position = [170 380 300 40];
            app.IntroLabel.Text = 'Francis Turbine Modeling';

            % Create HeadEditFieldLabel
            app.HeadEditFieldLabel = uilabel(app.UIFigure);
            app.HeadEditFieldLabel.HorizontalAlignment = 'right';
            app.HeadEditFieldLabel.Position = [220 290 35 22];
            app.HeadEditFieldLabel.Text = 'Head';

            % Create HeadEditField
            app.HeadEditField = uieditfield(app.UIFigure, 'numeric');
            app.HeadEditField.Position = [270 290 100 22];

            % Create DischargeEditFieldLabel
            app.DischargeEditFieldLabel = uilabel(app.UIFigure);
            app.DischargeEditFieldLabel.HorizontalAlignment = 'right';
            app.DischargeEditFieldLabel.Position = [190 260 65 22];
            app.DischargeEditFieldLabel.Text = 'Discharge';

            % Create DischargeEditField
            app.DischargeEditField = uieditfield(app.UIFigure, 'numeric');
            app.DischargeEditField.Position = [270 260 100 22];

            % Create RotationalSpeedEditFieldLabel
            app.RotationalSpeedEditFieldLabel = uilabel(app.UIFigure);
            app.RotationalSpeedEditFieldLabel.HorizontalAlignment = 'right';
            app.RotationalSpeedEditFieldLabel.Position = [155 230 100 22];
            app.RotationalSpeedEditFieldLabel.Text = 'Rotational Speed';

            % Create RotationalSpeedEditField
            app.RotationalSpeedEditField = uieditfield(app.UIFigure, 'numeric');
            app.RotationalSpeedEditField.Position = [270 230 100 22];

            % Create StreamlinesEditFieldLabel
            app.StreamlinesEditFieldLabel = uilabel(app.UIFigure);
            app.StreamlinesEditFieldLabel.HorizontalAlignment = 'right';
            app.StreamlinesEditFieldLabel.Position = [180 200 70 22];
            app.StreamlinesEditFieldLabel.Text = 'Streamlines';

            % Create StreamlinesEditField
            app.StreamlinesEditField = uieditfield(app.UIFigure, 'numeric');
            app.StreamlinesEditField.Position = [270 200 100 22];

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [265 130 70 22];
            app.CalculateButton.Text = 'Calculate';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FrancisTurbineApp

            % Create UIFigure and components
            createComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure);
            
            % Run the startup function
            runStartupFcn(app, @startupFcn);

            if nargout == 0
                clear app;
            end
        end

        % Code that executes after component creation
        function startupFcn(app)
            % Initialize your parameters here
            app.HeadEditField.Value = 30;
            app.DischargeEditField.Value = 39.9;
            app.RotationalSpeedEditField.Value = 400;
            app.StreamlinesEditField.Value = 69;
        end
    end
end
function CalculateButtonPushed(app, event)
    try
        % Define the parameters
        H = 30;
        Q = 39.9;
        nrpm = 400;
        N = 69;
        nr = 2 * pi * nrpm / 60;

        % Call the functions with the appropriate input arguments
        [P, ns, w, r2, d2, r1_new, d1_new, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, height] = t(H, Q, nr, N);
        [P, ns, w, r2, d2, r1_new, ~, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, height] = axialtry(H, Q, nr, N);

        [x1, y1, x2, y2, xl, yl, xt, yt] = meri_lines(Q, H, nr, N);
        % [lead_zr, trail_zr, hub_1_zr, hub_2_zr, hub_3_zr, shroud_1_zr, shroud_2_zr, shroud_3_zr] = bladegen(x1, y1, x2, y2, xl, yl, xt, yt);

        % Display successful message
        app.ErrorMessageLabel.Text = 'Calculation and plotting completed successfully.';

    catch exception
        % Display any error messages for troubleshooting
        errorMessage = ['Error: ', exception.message];
        app.ErrorMessageLabel.Text = errorMessage;
    end
end