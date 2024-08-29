/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex_bonus.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/26 14:58:36 by magahat           #+#    #+#             */
/*   Updated: 2024/08/28 12:06:49 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

static void	write_pipe(int i)
{
	while (i)
	{
		write(1, "pipe ", 6);
		i--;
	}
	write(1, "heredoc>", 9);
}

static void	here_doc(char *limit, int nb_cmd)
{
	char	*buf;
	int		tmp;
	int		len;

	len = ft_strlen(limit);
	tmp = open(".tmp", O_CREAT | O_WRONLY | O_TRUNC, 00644);
	if (tmp < 0)
		exit_handler(7);
	while (1)
	{
		write_pipe(nb_cmd - 1);
		if (get_next_line(&buf, 0) < 0)
			exit_handler(7);
		if (!ft_strncmp(buf, limit, len))
		{
			if (buf[len] == '\n' || buf[len] == '\0')
				break ;
		}
		ft_putendl_fd(buf, tmp);
		free(buf);
	}
	free(buf);
	close(tmp);
}

int	main(int argc, char **argv, char **envp)
{
	t_pipex	pipex;

	if (argc < 5)
		return (write(2, "ERR_INPUT\n", 11), 0);
	pipex.here_doc = 0;
	if (ft_strncmp(argv[1], "here_doc", 9) == 0)
	{
		if (argc < 6)
			return (write(2, "ERR_INPUT\n", 11), 0);
		pipex.here_doc = 1;
		here_doc(argv[2], argc - 4);
		open_fd(".tmp", argv[argc - 1], pipex.file, 1);
	}
	else
		open_fd(argv[1], argv[argc - 1], pipex.file, 0);
	pipex.nb_cmd = argc - 3 - pipex.here_doc;
	pipex.pipes = open_pipes(pipex.nb_cmd - 1);
	manage_cmd(argv, envp, pipex);
	waitpid(-1, NULL, 0);
	close_fd(pipex);
	unlink(".tmp");
	return (0);
}
