/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   files.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/08/25 11:25:56 by magahat           #+#    #+#             */
/*   Updated: 2024/08/26 18:30:53 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

int	*open_fd(char *infile, char *outfile, int *file, int i)
{
	if (i == 0)
	{
		file[0] = open(infile, O_RDONLY);
		file[1] = open(outfile, O_WRONLY | O_CREAT | O_TRUNC, 00644);
	}
	else
	{
		file[0] = open(".tmp", O_RDONLY);
		file[1] = open(outfile, O_WRONLY | O_CREAT | O_APPEND, 00644);
	}
	if (file[1] < 0)
	{
		close(file[0]);
		exit_handler(2);
	}
	if (file[0] < 0)
	{
		ft_putstr_fd("cannot open: ", 2);
		ft_putendl_fd(infile, 2);
	}
	return (file);
}

int	*open_pipes(int nb_cmd)
{
	int	*pipes;
	int	i;

	i = 0;
	pipes = (int *)malloc(sizeof(int) * 2 * nb_cmd);
	while (i < nb_cmd)
	{
		if (pipe(pipes + 2 * i) < 0)
			exit_handler(3);
		i++;
	}
	return (pipes);
}

static void	close_pipes(int *pipes, int nb_cmd)
{
	int	i;

	i = 0;
	while (i < (nb_cmd * 2))
	{
		if (pipes[i] < 0)
			i++;
		else
			close(pipes[i]);
		i++;
	}
}

void	close_fd(t_pipex pipex)
{
	close_pipes(pipex.pipes, pipex.nb_cmd - 1);
	free(pipex.pipes);
	close_pipes(pipex.file, 1);
}
