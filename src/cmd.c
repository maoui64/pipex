/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cmd.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/08/24 15:22:07 by magahat           #+#    #+#             */
/*   Updated: 2024/08/26 18:30:46 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

static char	*find_paths(char **envp)
{
	while (ft_strncmp("PATH", *envp, 4))
		envp++;
	return (*envp + 5);
}

static char	*get_cmd(char **envp, char *cmd)
{
	char	*tmp;
	char	*cmd_path;
	int		i;
	char	**paths;

	if (!cmd)
		return (NULL);
	paths = ft_split(find_paths(envp), ':');
	i = 0;
	while (paths[i])
	{
		tmp = ft_strjoin(paths[i], "/");
		cmd_path = ft_strjoin(tmp, cmd);
		free(tmp);
		if (access(cmd_path, F_OK) == 0)
		{
			free_double(paths);
			return (cmd_path);
		}
		free(cmd_path);
		i++;
	}
	free_double(paths);
	return (NULL);
}

void static	execute_cmd(char *cmd, char **envp)
{
	char	**cmd_arg;
	char	*cmd_path;

	cmd_arg = ft_split(cmd, ' ');
	cmd_path = get_cmd(envp, cmd_arg[0]);
	if (!cmd_path)
	{
		ft_putstr_fd("command not found: ", 2);
		ft_putendl_fd(cmd_arg[0], 2);
		free_double(cmd_arg);
		free(cmd_path);
		exit (1);
	}
	if (execve(cmd_path, cmd_arg, envp) == -1)
	{
		free_double(cmd_arg);
		free(cmd_path);
		exit_handler(6);
	}
}

static int	manage_in_out(int in, int out)
{
	if (in < 0)
		return (-1);
	dup2(in, 0);
	dup2(out, 1);
	return (0);
}

void	manage_cmd(char **argv, char **envp, t_pipex p)
{
	pid_t	pid;
	int		i;

	i = 0;
	while (i < p.nb_cmd)
	{
		pid = fork();
		if (pid == -1)
			exit_handler(4);
		if (!pid)
		{
			if (i == 0)
				p.err = manage_in_out(p.file[0], p.pipes[1]);
			else if (i == p.nb_cmd - 1)
				p.err = manage_in_out(p.pipes[2 * i - 2], p.file[1]);
			else
				p.err = manage_in_out(p.pipes[2 * i - 2], p.pipes[2 * i + 1]);
			close_fd(p);
			if (p.err == -1)
				exit (0);
			execute_cmd(argv[2 + i + p.here_doc], envp);
		}
		i++;
	}
}
