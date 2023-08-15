classdef myFrancisTurbineApp < matlab.apps.AppBase

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
        UITabGroup            matlab.ui.container.TabGroup
        VelocityTriangleTab   matlab.ui.container.Tab
        TriangleAxes          matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)
        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            try
                % Define the parameters
                H = app.HeadEditField.Value;
                Q = app.DischargeEditField.Value;
                nrpm = app.RotationalSpeedEditField.Value;
                N = app.StreamlinesEditField.Value;
                nr = 2 * pi * nrpm / 60;

                % Call the functions with the appropriate input arguments
                [P, ns, w, r2, d2, r1_new, d1_new, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, height] = t(H, Q, nr, N);
                [P, ns, w, r2, d2, r1_new, ~, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, height] = axialtry(H, Q, nr, N);

                [x1, y1, x2, y2, xl, yl, xt, yt] = meri_lines(Q, H, nr, N);
                % [lead_zr, trail_zr, hub_1_zr, hub_2_zr, hub_3_zr, shroud_1_zr, shroud_2_zr, shroud_3_zr] = bladegen(x1, y1, x2, y2, xl, yl, xt, yt);

                cla(app.TriangleAxes);
                u = [0, u1, u2];
                v = [0, vf1, vf2];
                quiver(app.TriangleAxes, [0, 0, 0], [0, 0, 0], u, v, 0);
                xlim(app.TriangleAxes, [-max(u), max(u)]);
                ylim(app.TriangleAxes, [0, max(v) * 1.1]);
                title(app.TriangleAxes, 'Velocity Triangle');
                xlabel(app.TriangleAxes, 'Axial Velocity (u)');
                ylabel(app.TriangleAxes, 'Tangential Velocity (v)');
                grid(app.TriangleAxes, 'on');

                % Display successful message
                app.ErrorMessageLabel.Text = 'Calculation and plotting completed successfully.';
            catch exception
                % Display any error messages for troubleshooting
                errorMessage = ['Error: ', exception.message];
                app.ErrorMessageLabel.Text = errorMessage;
            end
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

            % ... (other components)

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [265 130 70 22];
            app.CalculateButton.Text = 'Calculate';

            % Create UITabGroup
            app.UITabGroup = uitabgroup(app.UIFigure);
            app.UITabGroup.Position = [1 1 640 480];

            % Create the Velocity Triangle tab
            app.VelocityTriangleTab = uitab(app.UITabGroup);
            app.VelocityTriangleTab.Title = 'Velocity Triangle';

            % Create TriangleAxes
            app.TriangleAxes = uiaxes(app.VelocityTriangleTab);
            app.TriangleAxes.Position = [50 50 540 340];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)
        % Construct app
        function app = myFrancisTurbineApp

            % ... (existing code)

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