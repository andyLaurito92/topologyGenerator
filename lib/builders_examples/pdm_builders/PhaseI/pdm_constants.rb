PDM_INITIAL_STRUCTURE = "Coupled
    {
        Type = Root
        Name = MyTopology
        Ports = 0; 0
        Description = Testing the creation of a topology by getting the info from the controller
        Graphic
            {
                Position = 0; 0
                Dimension = 600; 600
                Direction = Right
                Color = 15
                Icon = 
                Window = 5000; 5000; 5000; 5000
            }
        Parameters
            {
            }
        System
            {
            Atomic
                {
                Name = LoadScilabParams
                Ports = 1 ; 0
                Path = sinks/RunScilabJob.h
                Description = If Scilab is configured as backed in the cmd line options, this model runs Scilab commands at Init, Exit and when receive events.
                Graphic
                    {
                    Position = -13845 ; -14220 
                    Dimension = 540 ; 540
                    Direction = Right
                    Color = 15
                    Icon = %sinks%scilab.ico
                    }
                Parameters
                    {
                    Run at Init = Str; exec('../examples/Matias/PhaseI/Scilab/model.scilabParams', 0) ; Scilab Job at Init
                    Run at External = Str;  ; Scilab Job when receive event
                    Run at Exit = Str;  ; Scilab Job at Exit
                    }
                }
            Atomic
                {
                Name = ExperimenetTracker
                Ports = 0 ; 0
                Path = sinks/SimulationExperimentTracker.h
                Description = Allows to use multiple simulation runs setting new parameter values in each run. It configures Scilab variables according to the current simunation number. This model should run with 1st priority!!
                Graphic
                    {
                    Position = -11220 ; -14220
                    Dimension = 540 ; 540
                    Direction = Right
                    Color = 15
                    Icon = %realtime%lcd.svg
                    }
                Parameters
                    {
                    ScilabSimulationSetID = Str; SimulationName ; indicates the simulation set ID
                    ScilabSimulationCounterVariableName = Str; ExperimentNumber ; Name of the Scilab variable that indicates the simulation number.
                    ScilabParametersVariableName = Str; ParameterValues ; Name of the Scilab variable that contains the parameter values for each simulation
                    ScilabParametersValuesVariableName = Str; ParameterNames ; Name of the Scilab variable that contains the parameter names for each simulation
                    }
                }
            Atomic
                {
                Name = UpdateScilabParams
                Ports = 1 ; 0
                Path = sinks/RunScilabJob.h
                Description = If Scilab is configured as backed in the cmd line options, this model runs Scilab commands at Init, Exit and when receive events.
                Graphic
                    {
                    Position = -8670 ; -14220
                    Dimension = 540 ; 540
                    Direction = Right
                    Color = 15
                    Icon = %sinks%scilab.ico
                    }
                Parameters
                    {
                    Run at Init = Str;  ; Scilab Job at Init
                    Run at External = Str;  ; Scilab Job when receive event
                    Run at Exit = Str;  ; Scilab Job at Exit
                    }
                }
        "

NUMBER_OF_PDM_MODELS_IN_STRUCTURE = 3

PDM_FINAL_STRUCTURE='    Atomic
                {
                Name = FinalizationCommands
                Ports = 0 ; 0
                Path = sinks/multipleSimulationCommands.h
                Description = Executes Scilab commands when using multiple simulation runs (at the end of each simulation, and at the end of ALL simulations).\nThis model should run with LAST priority
                Graphic
                    {
                    Position = -6270 ; -14220
                    Dimension = 540 ; 540
                    Direction = Right
                    Color = 15
                    Icon = %datanetworks%scilab.bmp
                    }
                Parameters
                    {
                    initSimulationCommandName = Str; ../examples/Matias/PhaseI/Scilab/firstSimulation.sce ; 
                    eachSimulationCommandName = Str; ../examples/Matias/PhaseI/Scilab/eachSimulation.sce ; 
                    lastSimulationCommandName = Str; ../examples/Matias/PhaseI/Scilab/lastSimulation.sce ; 
                    }
                }
            }
    }'