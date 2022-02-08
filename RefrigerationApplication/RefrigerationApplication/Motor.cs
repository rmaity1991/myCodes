using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RefrigerationApplication
{
    struct motorIn
    {
        public bool motorRunning;
        public bool motorStopped;
        public bool startMotor;
        public bool stopMotor;
        public bool motorSimulation;
    }
    struct motorOut
    {
        public bool motorOutput;
        public bool motorError;
    }
    class Motor
    {
        private motorIn Input;
        public motorOut Output;


        public virtual void startMotor()
        {
            if (Input.startMotor & (!Input.motorRunning))
            {
                Output.motorOutput = true;
                Input.startMotor = false;

                if (Input.motorSimulation)
                {
                    Input.motorRunning = true;
                }
                else
                {

                }
                
            }
        }

        public virtual void stopMotor()
        {
            if (Input.stopMotor & (Input.motorRunning))
            {
                Output.motorOutput = false;
                Input.stopMotor = false;

                if (Input.motorSimulation)
                {
                    Input.motorRunning = false;
                }
                else
                {

                }

            }
        }
    }
}
