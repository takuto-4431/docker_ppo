import gym
import os
#import mujoco_py
import mujoco
from agent import Agent
from train import Train
from play import Play

ENV_NAME = "Ant"
TRAIN_FLAG = True
test_env = gym.make(ENV_NAME + "-v4")
#test_env = gym.make(ENV_NAME + "-v4",render_mode="rgb_array")

n_states = test_env.observation_space.shape[0]
action_bounds = [test_env.action_space.low[0], test_env.action_space.high[0]]
n_actions = test_env.action_space.shape[0]

n_iterations = 500
lr = 3e-4
epochs = 10
clip_range = 0.2
mini_batch_size = 64
T = 2048

if __name__ == "__main__":
    print(f"number of states:{n_states}\n"
          f"action bounds:{action_bounds}\n"
          f"number of actions:{n_actions}")

    if not os.path.exists(ENV_NAME):
        os.mkdir(ENV_NAME)
        os.mkdir(ENV_NAME + "/logs")

    env = gym.make(ENV_NAME + "-v4")

    agent = Agent(n_states=n_states,
                  n_iter=n_iterations,
                  env_name=ENV_NAME,
                  action_bounds=action_bounds,
                  n_actions=n_actions,
                  lr=lr)
    if TRAIN_FLAG:
        trainer = Train(env=env,
                        test_env=test_env,
                        env_name=ENV_NAME,
                        agent=agent,
                        horizon=T,
                        n_iterations=n_iterations,
                        epochs=epochs,
                        mini_batch_size=mini_batch_size,
                        epsilon=clip_range)
        trainer.step()

    player = Play(env, agent, ENV_NAME)
    player.evaluate()
